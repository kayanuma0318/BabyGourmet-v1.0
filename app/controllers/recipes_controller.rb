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
    @categories = ['meat', 'fish', 'vegetable', 'seasoning', 'sweet', 'other', 'fruit', 'deli']
    prepare_foods_by_category
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
      # current_user: devise標準メソッドで、ログイン中のユーザー情報を取得
      # build: 現在ログイン中のオブジェクトを生成するメソッド
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

  def edit
    @categories = ['meat', 'fish', 'vegetable', 'seasoning', 'sweet', 'other', 'fruit', 'deli']
    prepare_foods_by_category
  end

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
    @recipe = Recipe.find_by(id: params[:id])
    # レシピが存在しない場合、レシピ一覧にリダイレクト
    if @recipe.nil?
      redirect_to recipes_path, danger: t('messages.not_found', model: Recipe.model_name.human)
    end
  end

  def recipe_params
    params.require(:recipe).permit(
      :title,
      :recipe_image,
      :one_point,
      :description,
      :serving_size,
      recipe_foods_attributes: [:id, :food_id, :quantity, :_destroy]
      # recipes_foods_attributes: レシピ投稿フォームでネストされた属性を許可する
      # _destroy: レシピ投稿フォームでレコードを削除する際に使用
    )
  end

  # 投稿者本人であるかを判定メソッド
  def authorize_user_recipe
    # 投稿者本人でない場合、レシピ一覧にリダイレクト
    unless @recipe.user == current_user
      redirect_to recipes_path, danger: t('messages.not_authorized')
    end
  end

  # カテゴリー毎の食材リストを準備するメソッド
  def prepare_foods_by_category
    @foods_by_category = {}
    # カテゴリー名をkeyとして、そのカテゴリーに属する食材リストをvalueとして格納するハッシュ
    @categories.each do |category|
      @foods_by_category[category] = Food.where(category: category)
      # 各カテゴリーに対応する食材のリストを取得し、@foods_by_category ハッシュに保存
      # Food.where(category: category) :データベースから特定のカテゴリーに属する全ての食材を取得するActiveRecordのクエリ
      #  @foods_by_category[category] :取得した食材のリストをハッシュに保存
    end
  end
end
