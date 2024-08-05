class Recipe < ApplicationRecord
  belongs_to :user
  has_many :foods, through: :recipe_foods
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true
  has_many :recipe_foods
  accepts_nested_attributes_for  :recipe_foods,
                                  allow_destroy: true,
                                  reject_if: :all_blank
                                  # reject_if: :all_blank = 全ての属性が空の場合、レコードを保存しない

  validates :title, presence: true
  validates :one_point, presence: true, length: { maximum: 500 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :serving_size, presence: true

  NUTRIENT_COLUMNS = %w[energy protein dietary_fiber calcium magnesium phosphorus iron zinc iodine vitamin_d vitamin_b6 vitamin_b12 folate vitamin_c salt_equivalent]

  # レシピに含まれる栄養素名を取得するメソッド
  def nutrient_names
    used_nutrients = Set.new
    # Set.new: 重複を許さない配列を生成するメソッド
    # 使用されている栄養素を格納するため,空の配列を作成
    recipe_foods.includes(food: { food_nutrients: :nutrient }).each do |recipe_food|
      # 個々のレシピに含まれる食材の中から食材の栄養素を取得し、それぞれ以下の処理を行う
      recipe_food.food.food_nutrients.each do |food_nutrient|
        # 各食材に含まれる栄養素に対してそれぞれ以下の処理を行う
        NUTRIENT_COLUMNS.each do |column|
          # 栄養素カラム名の配列を取得し、それぞれ以下の処理を行う
          value = food_nutrient.nutrient.send(column)
            # food_nutrientの特定の栄養素の値を取得する
            # 例: カラムがenergyの場合、food_nutrient.nutrient.energyとなり、energyの値を取得する
          used_nutrients.add(column) if value.present? && value > 0
            # 栄養素の値が存在し、0より大きい場合、その栄養素名を配列に追加する
        end
      end
    end
    used_nutrients.to_a
      # レシピに使用された栄養素名のリストを配列で返す
  end

  # レシピに含まれる栄養素の値を取得するメソッド
  def nutrient_totals
    totals = {}
    # 栄養素の合計値を格納する、空のハッシュを作成
    recipe_foods.each do |recipe_food|
      # レシピに含まれる食材の中からそれぞれ以下の処理を行う
      food = recipe_food.food
      # レシピに含まれる食材を取得する
      food.nutrients.each do |nutrient|
        # 食材に含まれる栄養素を取得し、それぞれ以下の処理を行う
        NUTRIENT_COLUMNS.each do |column|
          # 栄養素カラム名の配列を取得し、それぞれ以下の処理を行う
          value = nutrient.send(column)
            # 栄養素の特定のカラムの値を取得する
          if value && value > 0
            # 栄養素の値が存在し、0より大きい場合、以下の処理を行う
            totals[column] ||= 0
              # 栄養素の値が存在しない場合、0を代入する（nil防止のため）
            totals[column] += value * recipe_food.quantity / 100.0
            # 特定のカラム = 100gあたりの栄養素の値 * 使用される食材の量 / 100gあたりの値を実際の使用量に比例した値に変換
          end
        end
      end
    end
    totals
  end
end