FactoryBot.define do
  factory :business_registration do
    user { nil }
    business_name { "MyString" }
    business_category { nil }
    custom_business_description { "MyText" }
    country { nil }
    state { nil }
    ownership_type { 1 }
    employee_plans { 1 }
    revenue_expectation { 1 }
    growth_plans { 1 }
    current_step { 1 }
    status { 1 }
  end
end
