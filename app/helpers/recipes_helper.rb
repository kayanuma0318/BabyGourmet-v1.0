module RecipesHelper
  def get_badge_color(index)
    colors = ['badge-primary', 'badge-secondary', 'badge-accent', 'badge-info', 'badge-success', 'badge-warning']
    colors[index % colors.length]
  end

  # レシピに含まれる栄養素名のみを表示するメソッド（index）
  def nutrient_badges(recipe)
    safe_join(
      # safe_joinメソッド :配列の要素を結合して1つの要素にするメソッド
      recipe.nutrient_names.each_with_index.map do |nutrient, index|
        # .map :配列の要素を1つずつ取り出し、新しい配列を作成するメソッド
        #  各栄養素と栄養素カラムに対して以下の処理を行う
        badge_color = get_badge_color(index)
        content_tag :span, class: "badge #{badge_color} text-xs" do
          t("nutrients.#{nutrient}")
        end
      end
    )
  end

  # レシピに含まれる栄養素名と対応する栄養素の値を表示するメソッド（show）
  def nutrient_details(recipe)
    content_tag :div, class: "grid grid-cols-2 gap-4" do
      safe_join(
        # safe_joinメソッド :配列の要素を結合して1つの要素にするメソッド
        recipe.nutrient_totals.map do |nutrient, total|
          # .map :配列の要素を1つずつ取り出し、新しい配列を作成するメソッド
          #  各栄養素と栄養素の値に対して以下の処理を行う
          badge_color = get_badge_color(recipe.nutrient_names.index(nutrient.to_s))
            # レシピに含まれる栄養素名の配列から、特定の栄養素名のカラム(index)を取得し、そのカラム(index)に対応する色を取得する
          content_tag :div, class: "flex flex-col" do
            # flex flex-col: 要素を縦方向に並べる
            content_tag :div, class: "flex items-center mb-1" do
              # flex items-center: 要素を中央に配置する
              concat content_tag(:span, t("nutrients.#{nutrient}"), class: "badge #{badge_color} mr-2 text-xs px-2 py-1")
              concat content_tag(:span, "#{number_with_precision(total, precision: 2)} #{t("nutrient_units.#{nutrient}")}")
                # number_with_precisionメソッド :第1引数の数値を第2引数の桁数（小数点第2位まで）表示するメソッド
            end
          end
        end
      )
    end
  end
end
