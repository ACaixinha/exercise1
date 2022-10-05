class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 30
      t.string :encrypted_password
      t.string :role
      t.integer :deposit, default: 0

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
