class Notification < ApplicationRecord
  belongs_to :notified_user, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(5) }

  def mark_as_read!
    update!(read_at: Time.current)
  end
end
