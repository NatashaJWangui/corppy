class Document < ApplicationRecord
  belongs_to :business_registration
  belongs_to :document_template
end
