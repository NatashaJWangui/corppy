FactoryBot.define do
  factory :document_template do
    business_category { nil }
    country { nil }
    state { nil }
    template_name { "MyString" }
    template_content { "MyText" }
    required_fields { "" }
    fees { "9.99" }
    processing_time { "MyString" }
    active { false }
  end
end
