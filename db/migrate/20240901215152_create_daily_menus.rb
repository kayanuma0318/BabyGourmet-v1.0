class CreateDailyMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_menus do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :daily_menus, [:user_id, :recipe_id], unique: true
      # ユーザーは同じレシピを重複登録できないようにする記述
  end
end
