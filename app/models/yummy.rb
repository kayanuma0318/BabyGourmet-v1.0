class Yummy < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, counter_cache: true
  # counter_cache: true :yummyが作成されたり削除したりする度に、yummies_countカラムを自動的に更新し、カウントする

  has_many :notifications, as: :notifiable, dependent: :destroy
  after_create :create_notification

  private

  def create_notification
    return if self.recipe.user == self.user
    Notification.create(
      notified_user: self.recipe.user,
      notifiable: self,
      action_type: 'yummy'
    )
  end
end
