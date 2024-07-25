class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title,           null: false
      t.string :recipe_image
      t.text :one_point,         null: false
      t.text :description,       null: false
      t.integer :serving_size,   null: false

      t.timestamps
    end
  end
end
