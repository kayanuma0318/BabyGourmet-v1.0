class Recipe < ApplicationRecord
  validates :title, presence: true
  validates :one_point, presence: true
  validates :description, presence: true
  validates :serving_size, presence: true

  validates :one_point, length: { maximum: 500 }
  validates :description, length: { maximum: 500 }
end
