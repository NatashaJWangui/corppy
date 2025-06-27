class BusinessRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :business_category
  belongs_to :country
  belongs_to :state

  has_many :documents, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :ai_interactions, dependent: :destroy
  has_many :registration_steps, dependent: :destroy
  has_many :compliance_reviews, through: :documents

  validates :business_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :current_step, presence: true, inclusion: { in: 1..8 }
  validates :ownership_type, presence: true, if: -> { current_step >= 4 }
  validates :employee_plans, presence: true, if: -> { current_step >= 5 }
  validates :revenue_expectation, presence: true, if: -> { current_step >= 6 }
  validates :growth_plans, presence: true, if: -> { current_step >= 6 }

  enum status: {
    draft: 0,
    in_review: 1,
    document_generated: 2,
    awaiting_approval: 3,
    approved: 4,
    signed: 5,
    payment_pending: 6,
    paid: 7,
    compliance_review: 8,
    compliance_approved: 9,
    completed: 10,
    rejected: 11
  }

  enum ownership_type: {
    sole_proprietor: 0,
    partnership: 1,
    multi_owner: 2
  }

  enum employee_plans: {
    no_employees: 0,
    employees_1_5: 1,
    employees_6_plus: 2
  }

  enum revenue_expectation: {
    under_50k: 0,
    between_50k_250k: 1,
    over_250k: 2
  }

  enum growth_plans: {
    stable_business: 0,
    grow_quickly: 1,
    build_and_sell: 2
  }

  scope :active, -> { where.not(status: [ :completed, :rejected ]) }
  scope :recent, -> { order(created_at: :desc) }

  def progress_percentage
    (current_step.to_f / 8 * 100).round
  end

  def step_name
    steps = {
      1 => "Business Name",
      2 => "Business Type",
      3 => "Location",
      4 => "Team Structure",
      5 => "Business Goals",
      6 => "Contact Details",
      7 => "Review & Summary",
      8 => "Document & Payment"
    }
    steps[current_step]
  end

  def next_step!
    return false if current_step >= 8

    update!(current_step: current_step + 1)
    create_step_record
  end

  def previous_step!
    return false if current_step <= 1

    update!(current_step: current_step - 1)
  end

  def can_advance_to_step?(step)
    case step
    when 2
      business_name.present?
    when 3
      business_category.present? && custom_business_description.present?
    when 4
      country.present? && state.present?
    when 5
      ownership_type.present?
    when 6
      employee_plans.present?
    when 7
      revenue_expectation.present? && growth_plans.present?
    when 8
      user.first_name.present? && user.last_name.present? &&
      user.email.present? && user.phone.present? &&
      user.street_address.present? && user.city.present? && user.zip_code.present?
    else
      true
    end
  end

  def ready_for_document_generation?
    current_step == 8 && can_advance_to_step?(8)
  end

  def document_template
    DocumentTemplate.find_by(
      business_category: business_category,
      country: country,
      state: state,
      active: true
    )
  end

  def total_fees
    template = document_template
    return 0 unless template

    base_fee = template.fees
    service_fee = 50.00 # Corppy service fee

    base_fee + service_fee
  end

  def formatted_fees
    "$#{total_fees}"
  end

  def current_document
    documents.order(created_at: :desc).first
  end

  def latest_payment
    payments.order(created_at: :desc).first
  end

  def fully_paid?
    latest_payment&.completed?
  end

  private

  def create_step_record
    registration_steps.create!(
      step_number: current_step,
      step_name: step_name,
      step_data: build_step_data,
      completed_at: Time.current
    )
  end

  def build_step_data
    case current_step
    when 1
      { business_name: business_name }
    when 2
      {
        business_category_id: business_category_id,
        business_category_name: business_category&.name,
        custom_description: custom_business_description
      }
    when 3
      {
        country_id: country_id,
        country_name: country&.name,
        state_id: state_id,
        state_name: state&.name
      }
    when 4
      { ownership_type: ownership_type }
    when 5
      { employee_plans: employee_plans }
    when 6
      {
        revenue_expectation: revenue_expectation,
        growth_plans: growth_plans
      }
    when 7
      {
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        phone: user.phone,
        street_address: user.street_address,
        city: user.city,
        zip_code: user.zip_code
      }
    else
      {}
    end
  end
end
