FactoryBot.define do
  factory :e_signature do
    document { nil }
    user { nil }
    signed_at { "2025-06-27 00:16:07" }
    ip_address { "MyString" }
    signature_data { "MyText" }
    status { 1 }
    signature_image { "MyString" }
  end
end
