class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  has_many :notifications, as: :notifiable, dependent: :destroy
  after_create :create_notification

  validates :body, presence: true, length: { maximum: 256 }
  # コメントの空欄禁止
  # コメントの文字数制限256文字

  private

  def create_notification
    return if self.recipe.user == self.user
    Notification.create(
      notified_user: self.recipe.user,
      notifiable: self,
      action_type: 'comment'
    )
  end
end
