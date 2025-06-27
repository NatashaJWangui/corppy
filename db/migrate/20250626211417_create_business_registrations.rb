class CreateBusinessRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :business_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :business_name
      t.references :business_category, null: false, foreign_key: true
      t.text :custom_business_description
      t.references :country, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true
      t.integer :ownership_type
      t.integer :employee_plans
      t.integer :revenue_expectation
      t.integer :growth_plans
      t.integer :current_step
      t.integer :status

      t.timestamps
    end
  end
end
