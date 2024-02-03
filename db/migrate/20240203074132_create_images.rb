class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.integer :page_number, null: false
      t.references :book, null: false, foreign_key: true
      t.timestamps
    end
  end
end
