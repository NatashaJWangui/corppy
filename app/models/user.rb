class User < ApplicationRecord
  has_secure_password

  has_many :business_registrations, dependent: :destroy
  has_many :ai_interactions, dependent: :destroy
  has_many :e_signatures, dependent: :destroy
  has_many :compliance_reviews, foreign_key: "reviewer_id", dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :phone, presence: true, format: { with: /\A[\+]?[1-9][\d\s\-\(\)]{7,}\z/ }

  enum role: { user: 0, admin: 1, compliance_officer: 2 }

  scope :active, -> { where(active: true) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_address
    return "" unless street_address.present? && city.present?

    address_parts = [street_address, city]
    address_parts << zip_code if zip_code.present?
    address_parts.join(", ")
  end

  def display_email
    email
  end

  def can_review_documents?
    compliance_officer? || admin?
  end

  def can_manage_templates?
    admin?
  end

  def current_registration
    business_registrations.where(status: [ :draft, :in_review, :document_generated, :awaiting_approval ]).first
  end

  def completed_registrations
    business_registrations.where(status: :completed)
  end
end
