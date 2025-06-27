class BusinessCategory < ApplicationRecord
   has_many :business_registrations, dependent: :restrict_with_error
  has_many :document_templates, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true

  scope :active, -> { where(active: true) }

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
