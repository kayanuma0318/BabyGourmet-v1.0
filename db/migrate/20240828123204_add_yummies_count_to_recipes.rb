class AddYummiesCountToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :yummies_count, :integer, default: 0, null: false
  end
end
