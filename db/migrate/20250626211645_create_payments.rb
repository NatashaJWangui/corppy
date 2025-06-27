class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :business_registration, null: false, foreign_key: true
      t.references :document, null: false, foreign_key: true
      t.decimal :amount
      t.string :currency
      t.string :payment_method
      t.string :payment_provider
      t.string :transaction_id
      t.integer :status
      t.datetime :paid_at
      t.json :metadata

      t.timestamps
    end
  end
end
