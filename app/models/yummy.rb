class Yummy < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, counter_cache: true
  # counter_cache: true :yummyが作成されたり削除したりする度に、yummies_countカラムを自動的に更新し、カウントする

  has_many :notifications, as: :notifiable, dependent: :destroy
  after_create :create_notification
  # Yummyが作成された後にcreate_notificationメソッドを呼び出すコールバックを設定

  private

  # 通知を作成するメソッド
  def create_notification
    return if self.recipe.user == self.user
    # レシピの作成者とこのYummyを作成したユーザーが同じ場合、通知を作成しない

    Notification.create(
      notified_user: self.recipe.user,
      notifiable: self,
      action_type: 'yummy'
    )
  end
end
  # 1行目: 新しい通知をデータベースに作成
  # 2行目: notified_user: 通知を受け取るユーザー（レシピの作成者）
  # 3行目: notifiable: 通知の対象となるオブジェクト（このYummyインスタンス）
  # 4行目: action_type: 通知の種類を示す（'yummy'アクション）

  # 1. まず、Yummyを押した人がレシピの作成者と同じかチェックします。
  #    同じ場合は、自分のレシピに自分でYummyしたことになるので、通知は不要です。
  # 2. Yummyを押した人とレシピの作成者が異なる場合、新しい通知を作成します。
  # 3. 通知には以下の情報が含まれます：
  #    - 誰に通知するか（レシピの作成者）
  #    - 何について通知するか（このYummy）
  #    - どのような種類の通知か（Yummyについての通知）
