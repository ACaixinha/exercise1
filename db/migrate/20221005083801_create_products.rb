class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :amount_available
      t.integer :cost
      t.string :product_name
      t.references :seller, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
