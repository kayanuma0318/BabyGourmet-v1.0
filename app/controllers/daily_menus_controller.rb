class DailyMenusController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.daily_menu(recipe)

    respond_to do |format|
      format.turbo_stream
      redirect_to request.referer
    end
  end

  def destroy
    daily_menu = current_user.daily_menus.find_by(id: params[:id])
    recipe = daily_menu.recipe
    current_user.undaily_menu(recipe)
    # ログインしているユーザーの今日の献立の中から、指定されたidのレコードを取得
    # 削除対象のレシピを取得

    respond_to do |format|
      format.turbo_stream
      redirect_to request.referer
    end
  end
end
