class State < ApplicationRecord
  belongs_to :country
  has_many :business_registrations, dependent: :restrict_with_error
  has_many :document_templates, dependent: :restrict_with_error

  validates :name, presence: true
  validates :code, presence: true

  scope :active, -> { where(active: true) }

  def full_name
    "#{name}, #{country.name}"
  end
end
