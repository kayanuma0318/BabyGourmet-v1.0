class RecipeFood < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  validates :quantity, presence: true, if: -> { food.present? }
  # foodが存在する場合、quantityが存在することを検証
end