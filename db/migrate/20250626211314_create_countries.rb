class CreateCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.string :region
      t.boolean :active

      t.timestamps
    end
  end
end
