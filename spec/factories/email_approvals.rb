FactoryBot.define do
  factory :email_approval do
    document { nil }
    email { "MyString" }
    approval_token { "MyString" }
    approved_at { "2025-06-27 00:16:26" }
    expires_at { "2025-06-27 00:16:26" }
    status { 1 }
  end
end
