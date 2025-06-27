FactoryBot.define do
  factory :registration_step do
    business_registration { nil }
    step_number { 1 }
    step_name { "MyString" }
    step_data { "" }
    completed_at { "2025-06-27 00:20:49" }
  end
end
