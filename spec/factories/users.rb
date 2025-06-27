FactoryBot.define do
  factory :user do
    email { "MyString" }
    password_digest { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    phone { "MyString" }
    role { 1 }
    street_address { "MyString" }
    city { "MyString" }
    zip_code { "MyString" }
    country { "MyString" }
    created_at { "2025-06-27 00:06:02" }
    updated_at { "2025-06-27 00:06:02" }
  end
end
