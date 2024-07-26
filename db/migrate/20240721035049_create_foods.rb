class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :unit, null: false

      t.timestamps
    end
    add_index :foods, [:name, :category], unique: true
  end
end
