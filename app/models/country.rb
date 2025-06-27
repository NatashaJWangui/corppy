class Country < ApplicationRecord
  has_many :states, dependent: :destroy
  has_many :business_registrations, dependent: :restrict_with_error
  has_many :document_templates, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
end
