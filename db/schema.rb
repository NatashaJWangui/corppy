# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_26_212602) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ai_interactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "business_registration_id", null: false
    t.text "question"
    t.text "response"
    t.string "interaction_type"
    t.integer "step_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_registration_id"], name: "index_ai_interactions_on_business_registration_id"
    t.index ["user_id"], name: "index_ai_interactions_on_user_id"
  end

  create_table "business_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "icon"
    t.boolean "active"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "business_name"
    t.bigint "business_category_id", null: false
    t.text "custom_business_description"
    t.bigint "country_id", null: false
    t.bigint "state_id", null: false
    t.integer "ownership_type"
    t.integer "employee_plans"
    t.integer "revenue_expectation"
    t.integer "growth_plans"
    t.integer "current_step"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_category_id"], name: "index_business_registrations_on_business_category_id"
    t.index ["country_id"], name: "index_business_registrations_on_country_id"
    t.index ["state_id"], name: "index_business_registrations_on_state_id"
    t.index ["user_id"], name: "index_business_registrations_on_user_id"
  end

  create_table "compliance_reviews", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "reviewer_id", null: false
    t.integer "status"
    t.datetime "reviewed_at"
    t.text "notes"
    t.string "approval_decision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_compliance_reviews_on_document_id"
    t.index ["reviewer_id"], name: "index_compliance_reviews_on_reviewer_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "region"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_templates", force: :cascade do |t|
    t.bigint "business_category_id", null: false
    t.bigint "country_id", null: false
    t.bigint "state_id", null: false
    t.string "template_name"
    t.text "template_content"
    t.json "required_fields"
    t.decimal "fees"
    t.string "processing_time"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_category_id"], name: "index_document_templates_on_business_category_id"
    t.index ["country_id"], name: "index_document_templates_on_country_id"
    t.index ["state_id"], name: "index_document_templates_on_state_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "business_registration_id", null: false
    t.bigint "document_template_id", null: false
    t.text "generated_content"
    t.integer "status"
    t.string "file_path"
    t.datetime "generated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_registration_id"], name: "index_documents_on_business_registration_id"
    t.index ["document_template_id"], name: "index_documents_on_document_template_id"
  end

  create_table "e_signatures", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "user_id", null: false
    t.datetime "signed_at"
    t.string "ip_address"
    t.text "signature_data"
    t.integer "status"
    t.string "signature_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_e_signatures_on_document_id"
    t.index ["user_id"], name: "index_e_signatures_on_user_id"
  end

  create_table "email_approvals", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.string "email"
    t.string "approval_token"
    t.datetime "approved_at"
    t.datetime "expires_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_email_approvals_on_document_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "business_registration_id", null: false
    t.bigint "document_id", null: false
    t.decimal "amount"
    t.string "currency"
    t.string "payment_method"
    t.string "payment_provider"
    t.string "transaction_id"
    t.integer "status"
    t.datetime "paid_at"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_registration_id"], name: "index_payments_on_business_registration_id"
    t.index ["document_id"], name: "index_payments_on_document_id"
  end

  create_table "registration_steps", force: :cascade do |t|
    t.bigint "business_registration_id", null: false
    t.integer "step_number"
    t.string "step_name"
    t.json "step_data"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_registration_id"], name: "index_registration_steps_on_business_registration_id"
  end

  create_table "states", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.integer "role"
    t.string "street_address"
    t.string "city"
    t.string "zip_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "ai_interactions", "business_registrations"
  add_foreign_key "ai_interactions", "users"
  add_foreign_key "business_registrations", "business_categories"
  add_foreign_key "business_registrations", "countries"
  add_foreign_key "business_registrations", "states"
  add_foreign_key "business_registrations", "users"
  add_foreign_key "compliance_reviews", "documents"
  add_foreign_key "compliance_reviews", "users", column: "reviewer_id"
  add_foreign_key "document_templates", "business_categories"
  add_foreign_key "document_templates", "countries"
  add_foreign_key "document_templates", "states"
  add_foreign_key "documents", "business_registrations"
  add_foreign_key "documents", "document_templates"
  add_foreign_key "e_signatures", "documents"
  add_foreign_key "e_signatures", "users"
  add_foreign_key "email_approvals", "documents"
  add_foreign_key "payments", "business_registrations"
  add_foreign_key "payments", "documents"
  add_foreign_key "registration_steps", "business_registrations"
  add_foreign_key "states", "countries"
end
