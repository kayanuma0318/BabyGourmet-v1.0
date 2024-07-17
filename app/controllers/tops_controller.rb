class TopsController < ApplicationController
  def index
    if user_signed_in?
      # user_signed_in?: ログインしているかどうかを判定するdevise標準メソッド
      render 'index'
    else
      render 'gest_index'
    end
  end
end
