class DailyMenusController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @recipe = Recipe.find(params[:recipe_id])

    respond_to do |format|
      current_user.daily_menu(@recipe)
        # daily_menu(recipe) = user.rbに記載
      format.turbo_stream
    end
  end
  # 1. ログインしているユーザーが今日の献立にレシピを追加する
  # 2. findメソッドでレシピを取得
  # 3. 対象のレシピを引数にして、daily_menuメソッドを呼び出す
  # 4. レスポンスを create.turbo_stream.erb に返す

  def destroy
    daily_menu = current_user.daily_menus.find_by(id: params[:id])
    @recipe = daily_menu.recipe
    current_user.undaily_menu(@recipe)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
  # 1. undaily_menu(recipe) = user.rbに記載
  # 2. ログインしているユーザーの今日の献立の中から、指定されたidのレコードを取得
  # 3. 削除対象のレシピを取得
  # 4. 対象のレシピを引数にして、undaily_menuメソッドを呼び出す
  # 5. レスポンスを destroy.turbo_stream.erb に返す
