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
  validates :one_point, presence: true
  validates :description, presence: true
  validates :serving_size, presence: true

  validates :one_point, length: { maximum: 500 }
  validates :description, length: { maximum: 500 }

  # レシピに含まれる栄養素名を取得するメソッド
  def nutrient_names
    nutrient_columns = %w[energy protein dietary_fiber calcium magnesium phosphorus iron zinc iodine vitamin_d vitamin_b6 vitamin_b12 folate vitamin_c salt_equivalent]
    used_nutrients = Set.new
    # Set.new: 重複を許さない配列を生成するメソッド
    # 使用されている栄養素を格納するため,空の配列を作成
    recipe_foods.includes(food: { food_nutrients: :nutrient }).each do |recipe_food|
      recipe_food.food.food_nutrients.each do |food_nutrient|
        nutrient_columns.each do |column|
          value = food_nutrient.nutrient.send(column)
          used_nutrients.add(column) if value.present? && value > 0
        end
      end
    end
    used_nutrients.to_a
      # レシピに使用された栄養素名のリストを配列で返す
    end
  end

  def image_url
    ActionController::Base.helpers.asset_path('noimage.png')
  end

