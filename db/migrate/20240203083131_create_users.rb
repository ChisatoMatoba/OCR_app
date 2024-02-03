class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :login_name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end