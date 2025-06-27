# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Business Categories
BusinessCategory.create!([
  {
    name: "Technology & Software",
    slug: "technology-software",
    description: "Software Development, SaaS, tech startups",
    icon: "🖥️",
    active: true,
    sort_order: 1
  },
  {
    name: "Consulting & Services",
    slug: "consulting-services",
    description: "Professional Services, consulting, agencies",
    icon: "🤝",
    active: true,
    sort_order: 2
  },
  {
    name: "E-Commerce & Retail",
    slug: "ecommerce-retail",
    description: "Online Stores, retail businesses, dropshipping",
    icon: "🛒",
    active: true,
    sort_order: 3
  },
  {
    name: "Healthcare & Wellness",
    slug: "healthcare-wellness",
    description: "Medical services, wellness, health tech",
    icon: "🏥",
    active: true,
    sort_order: 4
  },
  {
    name: "Financial Services",
    slug: "financial-services",
    description: "Fintech, investment, financial consulting",
    icon: "💰",
    active: true,
    sort_order: 5
  },
  {
    name: "Manufacturing & Production",
    slug: "manufacturing-production",
    description: "Physical products, manufacturing, distribution",
    icon: "🏭",
    active: true,
    sort_order: 6
  },
  {
    name: "Real Estate",
    slug: "real-estate",
    description: "Property investment, real estate services",
    icon: "🏢",
    active: true,
    sort_order: 7
  }
])

# Countries
us = Country.create!(name: "United States", code: "US", region: "North America", active: true)

# US States (your 5 target states)
State.create!([
  { country: us, name: "Texas", code: "TX", active: true },
  { country: us, name: "Florida", code: "FL", active: true },
  { country: us, name: "Nevada", code: "NV", active: true },
  { country: us, name: "California", code: "CA", active: true },
  { country: us, name: "Delaware", code: "DE", active: true }
])

# Create document templates for each business category in each state
BusinessCategory.all.each do |category|
  State.all.each do |state|
    DocumentTemplate.create!(
      business_category: category,
      country: us,
      state: state,
      template_name: "#{category.name} Registration - #{state.name}",
      template_content: DocumentTemplate.generate_template_content(category, state),
      required_fields: {
        "business_name" => "required",
        "business_address" => "required",
        "registered_agent" => state.code == "DE" ? "required" : "optional",
        "ein_number" => "auto_generated",
        "shares_authorized" => "required"
      },
      fees: DocumentTemplate.calculate_state_fees(state.code),
      processing_time: "5-7 business days",
      active: true
    )
  end
end

# Admin user
User.create!(
  email: "admin@corppy.com",
  password_digest: BCrypt::Password.create("password123"),
  first_name: "Admin",
  last_name: "User",
  role: "admin"
)

# Compliance Officer
User.create!(
  email: "compliance@corppy.com",
  password_digest: BCrypt::Password.create("password123"),
  first_name: "Compliance",
  last_name: "Officer",
  role: "compliance_officer"
)

puts "✅ Seed data created successfully!"
