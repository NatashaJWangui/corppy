class CreateAiInteractions < ActiveRecord::Migration[8.0]
  def change
    create_table :ai_interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :business_registration, null: false, foreign_key: true
      t.text :question
      t.text :response
      t.string :interaction_type
      t.integer :step_number

      t.timestamps
    end
  end
end
