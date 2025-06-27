class RegistrationStep < ApplicationRecord
  belongs_to :business_registration

  validates :step_number, presence: true, inclusion: { in: 1..8 }
  validates :step_name, presence: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :for_step, ->(step) { where(step_number: step) }
end
