class ComplianceReview < ApplicationRecord
  belongs_to :document
  belongs_to :reviewer, class_name: "User"

  validates :status, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2, completed: 3 }

  scope :recent, -> { order(created_at: :desc) }

  delegate :business_registration, to: :document
end
