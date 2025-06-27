class CreateRegistrationSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :registration_steps do |t|
      t.references :business_registration, null: false, foreign_key: true
      t.integer :step_number
      t.string :step_name
      t.json :step_data
      t.datetime :completed_at

      t.timestamps
    end
  end
end
