class Notification < ApplicationRecord
  belongs_to :notified_user, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  # 未読の通知を取得するスコープ
  scope :unread, -> { where(read_at: nil) }
  # 最新の通知を5件取得するスコープ
  scope :recent, -> { order(created_at: :desc).limit(5) }

  # 通知を既読にマークするメソッド
  def mark_as_read!
    update!(read_at: Time.current)
  end
end
# このクラスの説明:
# notified_userは通知を受け取るユーザーを指し、notifiableは通知の対象となるオブジェクトを指します。
# スコープunreadは未読の通知のみを取得し、recentは最新の5件の通知を取得します。
# mark_as_read!メソッドは通知を既読として更新します。
