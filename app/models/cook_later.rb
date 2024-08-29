class Cooklater < ApplicationRecord
  belong_to :user
  belong_to :recipe

  validates :user_id, uniqueness: { scope: :recipe_id }
    # 1人のユーザーは1つのレシピに対して、1つのCooklaterしか作成できない
end
