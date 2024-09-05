class DailyMenu < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user_id, uniqueness: { scope: :recipe_id }
    # 1人のユーザーは1つのレシピに対して、1つのDailyMenuしか作成できない

  # ユーザーが今日のおかずに追加した各レシピの栄養素を合算して表示するメソッド
  def self.total_nutrients_user(user)
    totals = {}
    user.daily_menus.includes(recipe: { recipe_foods: { food: :nutrients } }).each do |daily_menu|
      daily_menu.recipe.nutrient_totals.each do |nutrient, value|
        totals[nutrient] ||= 0
        totals[nutrient] += value
      end
    end
    totals
  end
end

# 1. 栄養素を計算したいユーザー(current_user)を引数に取り、daily_menu全体で使用できるクラスメソッドを定義する
# 2. 空のハッシュを用意する
# 3. ユーザーが追加した全レシピを取得する{レシピ: {使用される食材: {食材名： :各栄養素名}}}の形で取得し、daily_menuへ代入する
# (。includesメソッドを使用して、N+1問題を回避する)
# 4. 今日の献立に追加されたレシピの栄養素を計算し、{栄養素名: 合計値}の形で取り出し、以下の処理を施してからtotalsに代入する
# 5. ハッシュ内の栄養素の値がない場合は０を代入する
# 6. ハッシュ内の栄養素の値に、栄養素の値を全体の合計に加算する
# 7. 合計値を返す
