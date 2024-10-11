class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  has_many :notifications, as: :notifiable, dependent: :destroy
  after_create :create_notification

  validates :body, presence: true, length: { maximum: 256 }
  # コメントの空欄禁止
  # コメントの文字数制限256文字

  private

  # コメントが作成された時に通知を生成するメソッド
  def create_notification
    return if self.recipe.user == self.user
    # コメントの作成者がレシピの作成者と同じ場合は通知を作成しない

    Notification.create(
      notified_user: self.recipe.user,
      notifiable: self,
      action_type: 'comment'
    )
  end
end
      # 1行目: 新しい通知を作成
      # 2行目: 通知を受け取るユーザー（レシピの作成者）
      # 3行目: 通知の対象となるオブジェクト（このコメント）
      # 4行目: 通知のタイプ（コメント）

  # 1. まず、コメントを投稿した人がレシピの作成者と同じかチェックします。
  #    同じ場合は、自分のレシピに自分でコメントしたことになるので、通知は不要です。
  # 2. コメントを投稿した人とレシピの作成者が異なる場合、新しい通知を作成します。
  # 3. 通知には以下の情報が含まれます：
  #    - 誰に通知するか（レシピの作成者）
  #    - 何について通知するか（このコメント）
  #    - どのような種類の通知か（コメントについての通知）
