class YummiesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    recipe = Recipe.find(params[:recipe_id])
    yummy = current_user.yummies.build(recipe: recipe)
      # newではなく、buildメソッドを使用することで、user_idを自動で設定される

    respond_to do |format|
      if yummy.save
        format.turbo_stream
        redirect_to request.referer
          # リクエスト元にリダイレクトする
      end
    end
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    yummy = current_user.yummies.find_by(recipe_id: recipe.id)

    respond_to do |format|
      if yummy.destroy
        format.turbo_stream
        redirect_to request.referer
          # リクエスト元にリダイレクトする
      end
    end
  end
end
