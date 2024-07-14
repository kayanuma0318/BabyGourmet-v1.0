class User < ApplicationRecord
  #nameバリデーション
  validates :name, presence: true, length: { maximum: 30 }

  #emailバリデーション
  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  # passwordバリデーション
  has_secure_password
  # ハッシュ化したパスワードをpassword_digestカラムに保存する
  # passwordとpassword_confirmationの値が一致するかどうかのバリデーションが追加される
  # authenticateメソッドが使えるようになる
  validates :password,  presence: true,
                        length: { minimum: 6 },
                        allow_nil: true
                        # プロフィール情報更新時にパスワードを変更しない場合にpasswordがnilでもバリデーションが通るようになる
end
