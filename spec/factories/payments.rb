FactoryBot.define do
  factory :payment do
    business_registration { nil }
    document { nil }
    amount { "9.99" }
    currency { "MyString" }
    payment_method { "MyString" }
    payment_provider { "MyString" }
    transaction_id { "MyString" }
    status { 1 }
    paid_at { "2025-06-27 00:16:45" }
    metadata { "" }
  end
end
