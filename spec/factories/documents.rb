FactoryBot.define do
  factory :document do
    business_registration { nil }
    document_template { nil }
    generated_content { "MyText" }
    status { 1 }
    file_path { "MyString" }
    generated_at { "2025-06-27 00:15:36" }
  end
end
