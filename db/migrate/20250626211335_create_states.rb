class CreateStates < ActiveRecord::Migration[8.0]
  def change
    create_table :states do |t|
      t.references :country, null: false, foreign_key: true
      t.string :name
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
