module RecipesHelper
  include ApplicationHelper

  # 栄養素名に対応する色をviewに返すメソッド(recipes/show)
  def get_badge_color(nutrient)
    color = get_nutrient_color(nutrient)
      # get_nutrient_color(nutrient) :各栄養素名に対応する色をviewに返すメソッド(application_helper.rbに記載)
    if nutrient == 'energy'
      text_color = 'text-black'
    else
      text_color = 'text-white'
    end
    "badge #{text_color} bg-[#{color}]"
      # text_color :energyの場合は黒文字、それ以外の栄養素名の文字色を白に設定
      # color :栄養素名に対応する色を取得
  end

  # レシピに含まれる栄養素名のみを表示するメソッド（index）
  def nutrient_badges(recipe)
    recipe.nutrient_names.map do |nutrient|
      # recipe.nutrient_names :各レシピに含まれる栄養素名を取得
      # .map do |nutrient| :新しい空の配列を作成し、nutrientに代入
      text_color = if nutrient == 'energy'
                      'text-black'
                    else
                      'text-white'
                    end
      {
        name: nutrient,
        color: get_nutrient_color(nutrient),
          # 各栄養素名に対応する色をviewに返すメソッド(application_helper.rbに記載)
        text_color: text_color
      }
    end
  end
end
