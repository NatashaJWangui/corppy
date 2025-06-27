class DocumentTemplate < ApplicationRecord
  belongs_to :business_category
  belongs_to :country
  belongs_to :state, optional: true

  has_many :documents, dependent: :restrict_with_error

  validates :template_name, presence: true
  validates :template_content, presence: true
  validates :fees, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }

  def formatted_fees
    "$#{fees}"
  end
end
