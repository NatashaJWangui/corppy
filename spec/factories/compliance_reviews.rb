FactoryBot.define do
  factory :compliance_review do
    document { nil }
    reviewer { nil }
    status { 1 }
    reviewed_at { "2025-06-27 00:18:57" }
    notes { "MyText" }
    approval_decision { "MyString" }
  end
end
