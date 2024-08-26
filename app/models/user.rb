class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :yummies, dependent: :destroy
  # dependent: :destroy : Userが削除されたら、そのUserに紐づくRecipe,comment,yummyも削除される

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :recoverable, :rememberable
  devise :database_authenticatable, :registerable, :validatable

  #nameバリデーション
  validates :name,  presence: true,
                    length: { maximum: 30 }

  #emailバリデーション
  validates :email, uniqueness: true

  # validatable: email, passwordのバリデーションが行われるため、バリデーション不要
  # emai: formatが適切か、空欄ではないか
  # password: 空欄ではないか、6文字以上20字以内であるか、少なくとも文字、数字、特殊文字が各1文字ずつ必要、確認用パスワードと一致しているか
  # config/initializers/devise.rb: 設定記載あり

  #avatarカラムの画像アップロード
  mount_uploader :avatar, AvatarUploader

  # ユーザーが行ったかを判定するメソッド
  def own?(object)
    id == object&.user_id
      # idがobjectのuser_idと一致するかを判定する
      # 使用例: current_user.own?(comment) = current_user.id == comment.user_idをしていることと同じとなる
      # 現在のコメントがログインしているユーザーのコメントかを判定する
  end
end
