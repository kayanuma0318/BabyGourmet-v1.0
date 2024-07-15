# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      # DBに保存するパスワードを暗号化して保存する
      t.string :name,               null: false
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      ## Rememberable
      # cookieを使用して、ユーザー情報を記憶する
      # t.datetime :remember_created_at

      ## Recoverable
      # パスワードリセット機能を提供する
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Trackable
      # ログイン回数、最終ログイン日時、最終ログインIPアドレスを記録する
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # サインインした時にメールを送信し、アカウントが有効になったかを確認する
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # ログイン試行回数を記録し、一定回数を超えた場合にアカウントをロックする
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
