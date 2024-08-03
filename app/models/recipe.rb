class Recipe < ApplicationRecord
  belongs_to :user
  has_many :foods, through: :recipe_foods
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true
  has_many :recipe_foods
  accepts_nested_attributes_for :recipe_foods, allow_destroy: true

  validates :title, presence: true
  validates :one_point, presence: true
  validates :description, presence: true
  validates :serving_size, presence: true

  validates :one_point, length: { maximum: 500 }
  validates :description, length: { maximum: 500 }
end
