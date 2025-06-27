class CreateESignatures < ActiveRecord::Migration[8.0]
  def change
    create_table :e_signatures do |t|
      t.references :document, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :signed_at
      t.string :ip_address
      t.text :signature_data
      t.integer :status
      t.string :signature_image

      t.timestamps
    end
  end
end
