class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.integer :role
      t.string :street_address
      t.string :city
      t.string :zip_code
      t.string :country

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
