FactoryBot.define do
  factory :state do
    country { nil }
    name { "MyString" }
    code { "MyString" }
    active { false }
  end
end
