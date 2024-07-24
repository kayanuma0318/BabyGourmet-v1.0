class CreateFoodNutrients < ActiveRecord::Migration[7.1]
  def change
    create_table :food_nutrients do |t|
      t.references :food, null: false, foreign_key: true
      t.references :nutrient, null: false, foreign_key: true
      # FoodとNutrientの関連付け
      t.float :amount
      # 食材の使用量を表すカラム

      t.timestamps
    end
    add_index :food_nutrients, [:food_id, :nutrient_id], unique: true
  end
end
