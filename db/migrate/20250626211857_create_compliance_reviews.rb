class CreateComplianceReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :compliance_reviews do |t|
      t.references :document, null: false, foreign_key: true
      t.references :reviewer, null: false, foreign_key: { to_table: :users }
      t.integer :status
      t.datetime :reviewed_at
      t.text :notes
      t.string :approval_decision

      t.timestamps
    end
  end
end
