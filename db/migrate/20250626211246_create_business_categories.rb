class CreateBusinessCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :business_categories do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :icon
      t.boolean :active
      t.integer :sort_order

      t.timestamps
    end
  end
end
