class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :body, presence: true, length: { maximum: 256 }
  # コメントの空欄禁止
  # コメントの文字数制限256文字
end
