FactoryBot.define do
  factory :ai_interaction do
    user { nil }
    business_registration { nil }
    question { "MyText" }
    response { "MyText" }
    interaction_type { "MyString" }
    step_number { 1 }
    created_at { "2025-06-27 00:20:27" }
  end
end
