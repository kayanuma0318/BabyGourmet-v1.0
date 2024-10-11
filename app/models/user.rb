class User < ApplicationRecord

  # 1人のユーザーは以下の情報を複数持つことができる
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :yummies, dependent: :destroy
  has_many :notifications, foreign_key: :notified_user_id, dependent: :destroy
  has_many :cook_laters, dependent: :destroy
  has_many :cook_later_recipes, through: :cook_laters, source: :recipe
  has_many :daily_menus, dependent: :destroy
  has_many :daily_menu_recipes, through: :daily_menus, source: :recipe
    # ユーザーはthroughを通じてrecipeの情報を取得できる
    # dependent: :destroy : Userが削除されたら、そのUserに紐づくRecipe,comment,yummyも削除される
    # user.(モデル名)_recipesで、ユーザーが「作りたいものリスト」へ追加したレシピを取得できる

  # バリデーション関連(コメントアウト内容はdevise.rbで行われる)
  # emai: formatが適切か、空欄ではないか
  # password: 空欄ではないか、6文字以上20字以内であるか
  devise :database_authenticatable, :registerable, :validatable
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, uniqueness: true
  validates :password_confirmation, presence: true, if: :password_required?
    # if: :password_required?で、更新時パスワード必要な場合のみバリデーションを行う(password_required?メソッドはuser.rb下部に記述)
  # パスワード、メールアドレスのバリデーションはconfig/initializers/devise.rbで行われるため、重複に注意する

  # avatarカラムの画像アップロード
  mount_uploader :avatar, AvatarUploader

  # 現在のコメントがログインしているユーザーのコメントかを判定するメソッド(comment機能)
  def own?(object)
    id == object&.user_id
  end
    # idがobjectのuser_idと一致するかを判定する
    # 使用例: current_user.own?(comment) = current_user.id == comment.user_idをしていることと同じとなる

  # 作りたいものリストに追加するメソッド
  def cook_later(recipe)
    cook_later_recipes << recipe
  end

  # 作りたいものリストから削除するメソッド
  def uncook_later(recipe)
    cook_later_recipes.destroy(recipe)
  end

  # 作りたいものリスト追加してあるかを判定するメソッド
  def cook_later?(recipe)
    cook_later_recipes.include?(recipe)
  end

  # レシピを今日のおかずに追加するメソッド
  def daily_menu(recipe)
    if daily_menu_recipes.count < 5
      daily_menu_recipes << recipe
    end
  end

  # レシピを今日のおかずから削除するメソッド
  def undaily_menu(recipe)
    daily_menu_recipes.destroy(recipe)
  end

  # レシピが今日のおかずに追加されているかを判定するメソッド
  def daily_menu?(recipe)
    daily_menu_recipes.include?(recipe)
  end

  # 今日の献立に追加したレシピの栄養素を合算するメソッド(daily_menu.rbに記載)
  def add_recipes_nutrients
    DailyMenu.total_nutrients_user(self)
  end
    # Userモデルに記載することで、current_user.add_recipes_nutrientsで、ユーザーが今日のおかずに追加したレシピ達の各栄養素の値を合算取得できる

  private

  # パスワード変更時のみバリデーションを行うメソッド
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
    # persisted? : ユーザーがDBに保存されているかを判定する
    # パスワードがnilではないか、パスワード確認がnilではないかを判定する
end
