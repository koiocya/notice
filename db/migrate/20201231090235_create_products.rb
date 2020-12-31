class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.text :name,       null: false
      t.integer :price,   null: false
      t.text :code,       null: false

      t.timestamps
    end
  end
end
