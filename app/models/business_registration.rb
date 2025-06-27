class BusinessRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :business_category
  belongs_to :country
  belongs_to :state
end
