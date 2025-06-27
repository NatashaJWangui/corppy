class CreateDocumentTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :document_templates do |t|
      t.references :business_category, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true
      t.string :template_name
      t.text :template_content
      t.json :required_fields
      t.decimal :fees
      t.string :processing_time
      t.boolean :active

      t.timestamps
    end
  end
end
