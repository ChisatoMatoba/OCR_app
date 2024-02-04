class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :book_name, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
