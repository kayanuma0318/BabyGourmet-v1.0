class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action :authorize_user_recipe, only: %i[edit update destroy]
  # authenticate_user!: ログインしていない場合、ログインページにリダイレクトするdevise標準メソッド
  # set_recipe: 対象のレシピを取得
  # authorize_user_recipe: レシピの編集、更新、削除する際、投稿者本人であるかを判定


  def index
    @recipes = Recipe.includes(:user).all
    # レシピ取得時にユーザー情報も取得
    # includesメソッド: N+1問題を解消するために使用
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
      # current_user: devise標準メソッドで、ログイン中のユーザー情報を取得
      # buildメソッド: 現在ログイン中のオブジェクトを生成するメソッド
      # userとrecipeが紐付き、自動でuser_idが設定され、ログイン中のユーザーが投稿者として登録される
    if @recipe.save
      redirect_to @recipe, success: t('messages.save_success', model: Recipe.model_name.human)
      # ユーザーが投稿したレシピの詳細ページにリダイレクト
    else
      flash.now[:danger] = t('messages.save_failed', model: Recipe.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, success: t('messages.update_success', model: Recipe.model_name.human)
      # ユーザーが投稿したレシピの詳細ページにリダイレクト
    else
      flash.now[:danger] = t('messages.update_failed', model: Recipe.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy!
    redirect_to recipes_path, success: t('messages.destroy_success', model: Recipe.model_name.human)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :title,
      :recipe_image,
      :one_point,
      :description,
      :serving_size
    )
  end

  def authorize_user_recipe
    # 投稿者本人でない場合、トップページにリダイレクト
    unless @recipe.user == current_user
    redirect_to recipes_path, danger: t('messages.not_authorized')
  end
end
