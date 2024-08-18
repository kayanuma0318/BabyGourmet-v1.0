module ApplicationHelper
  def flash_class(type)
    # 記述しない場合、格viewファイルでtypeに応じたクラスを毎回指定する必要があるので、この記述は必要である
    case type.to_sym
    when :success then "alert-success"
    when :danger then "alert-error"
    else "alert-info"
      # 予期せぬフラッシュメッセージの場合は、alert-infoを返す
    end
  end

  # 各栄養素に対応する色を定義(recipes/show)
  def nutrient_colors
    {
      'energy' => '#FCFF20',
      'protein' => '#E3716C',
      'dietary_fiber' => '#00b400',
      'calcium' => '#00baff',
      'magnesium' => '#8FBCBC',
      'phosphorus' => '#691730',
      'iron' => '#E6650D',
      'zinc' => '#576275',
      'iodine' => '#D1B6DD',
      'vitamin_d' => '#ffcd00',
      'vitamin_b6' => '#009c9c',
      'vitamin_b12' => '#ff92aa',
      'folate' => '#00843f',
      'vitamin_c' => '#fadf9a',
      'salt_equivalent' => '#00e9ff'
    }
  end

  # 各栄養素名に対応する色をviewに返すメソッド(recipes/show)
  def get_nutrient_color(nutrient)
    nutrient_colors[nutrient]
  end
end