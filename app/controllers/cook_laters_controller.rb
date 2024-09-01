class CookLatersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.cook_later(recipe)

    respond_to do |format|
      format.turbo_stream
      redirect_to request.referer
    end
  end

  def destroy
    cook_later = current_user.cook_laters.find_by(id: params[:id])
      # ログイン中のユーザーに紐づくcook_latersの中から、指定されたidを持つcook_laterを取得
    recipe = cook_later.recipe
      # uncook_laterメソッドで使用するrecipeを定義(cook_laterに紐づくrecipeを取得)
    current_user.uncook_later(recipe)

    respond_to do |format|
      format.turbo_stream
      redirect_to request.referer
    end
  end
end
