class CreateTexts < ActiveRecord::Migration[7.1]
  def change
    create_table :texts do |t|
      t.references :image, null: false, foreign_key: true
      t.text :content
      t.text :fixed_content

      t.timestamps
    end
  end
end
