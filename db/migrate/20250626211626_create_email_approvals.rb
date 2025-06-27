class CreateEmailApprovals < ActiveRecord::Migration[8.0]
  def change
    create_table :email_approvals do |t|
      t.references :document, null: false, foreign_key: true
      t.string :email
      t.string :approval_token
      t.datetime :approved_at
      t.datetime :expires_at
      t.integer :status

      t.timestamps
    end
  end
end
