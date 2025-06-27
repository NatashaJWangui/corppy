class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :business_registration, null: false, foreign_key: true
      t.references :document_template, null: false, foreign_key: true
      t.text :generated_content
      t.integer :status
      t.string :file_path
      t.datetime :generated_at

      t.timestamps
    end
  end
end
