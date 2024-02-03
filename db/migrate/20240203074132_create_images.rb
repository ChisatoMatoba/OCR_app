class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.integer :page_number

      t.timestamps
    end
  end
end
