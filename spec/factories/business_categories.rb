FactoryBot.define do
  factory :business_category do
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    icon { "MyString" }
    active { false }
    sort_order { 1 }
  end
end
