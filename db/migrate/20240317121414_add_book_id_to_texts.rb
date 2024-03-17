class AddBookIdToTexts < ActiveRecord::Migration[7.1]
  def change
    add_column :texts, :book_id, :integer
    add_index :texts, :book_id
  end
end
