class CreateCookLaters < ActiveRecord::Migration[7.1]
  def change
    create_table :cook_laters do |t|
      t.references :user, foreign_key: true
      t.references :recipe, foreign_key: true

      t.timestamps
      add_index :cook_laters, [:user_id, :recipe_id], unique: true
        # 同じuser_idとrecipe_idの組み合わせが重複しないようにする
    end
  end
end