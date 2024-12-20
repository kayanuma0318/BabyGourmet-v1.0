class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_not_exist_recipe, only: %i[show edit update destroy]
  before_action :authorize_user_recipe, only: %i[edit update destroy]
  before_action :set_categories_and_foods, only: %i[new create edit update]
  # authenticate_user!: ログインしていない場合、ログインページにリダイレクトするdevise標準メソッド
  # set_not_exist_recipe: 対象のレシピを取得し、レシピの存在を確認するメソッド
  # authorize_user_recipe: レシピの編集、更新、削除する際、投稿者本人であるかを判定
  # set_categories_and_foods: カテゴリーと食材をハッシュに格納するメソッド

  def index
    @recipes = Recipe.includes(:user, recipe_foods: { food: { food_nutrients: :nutrient } }).order(created_at: :desc).page(params[:page])
    # レシピ取得時にユーザー情報も取得
    # includesメソッド: N+1問題を解消するために使用
  end

  def new
    @recipe = Recipe.new
    @recipe.steps.build
    # 手順フォームの初期フォームを1つ作成する
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

  def show
  @recipe = Recipe.includes(:user, recipe_foods: { food: { food_nutrients: :nutrient } }).find(params[:id])
    # 特定のレシピを取得し、ユーザー情報も取得
  @nutrient_totals = @recipe.nutrient_totals
    #@recipe.nutrient_totalsを呼び出し、レシピ全体の栄養素合計を計算し、@nutrient_totalsに代入
  @comment = Comment.new
  @comments = @recipe.comments.includes(:user).order(created_at: :desc)
    # 個々のレシピに対して、コメントしたコメント情報とコメントしたユーザー情報を取得
  end

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
    @recipe.destroy
    redirect_to recipes_path, success: t('messages.destroy_success', model: Recipe.model_name.human)
  end

  # 作りたいものリストに追加したレシピ一覧を表示するメソッド(作りたいものリスト一覧にて使用)
  def cook_laters
    @cook_later_recipes = current_user.cook_later_recipes.includes(:user).order(created_at: :desc).page(params[:page])
  end

  # 今日の献立に追加したレシピ一覧を表示するアクション(今日の献立一覧にて使用)
  def daily_menus
    @daily_menu_recipes = current_user.daily_menu_recipes.includes(:user).order(created_at: :desc)
    @total_nutrients = current_user.add_recipes_nutrients
    # daily_menuに追加したレシピを取得する際にユーザー情報も一緒に取得し、N+1問題を回避、作成順に並べる
    # ログイン中のユーザーの今日のおかずに追加したレシピの栄養素を合算するメソッドを呼び出し、@total_nutrientsに代入
  end

  # 新規食材フォームを追加するメソッド
  def add_ingredient_fields
    @category = params[:category]
    @foods = Food.where(category: @category)
    respond_to do |format|
      format.turbo_stream
    end
  end

  # 追加した食材欄を削除するメソッド
  def remove_ingredient_fields
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.remove("ingredient_#{params[:field_id]}")
      end
    end
  end

  # 食材初期フィールドにて入力中の食材をリセットするメソッド
  def reset_ingredient_fields
    @category = params[:category]
      # リクエストパラメーターから食材の特定のカテゴリーを取得
    @foods = Food.where(category: @category)
      # 特定されたカテゴリーに属する食材をDBから取得
    @foods_by_category = { @category => @foods }
      # 取得した食材リストをカテゴリーごとにハッシュに格納
      # viewでカテゴリーごとに食材リストを表示するため
    @recipe = Recipe.new
    # 空のレシピオブジェクトを生成、リセット時に使用

    respond_to do |format|
      format.turbo_stream
    end
  end

  # 新規手順フォームを追加するメソッド
  def add_step_fields
    respond_to do |format|
      format.turbo_stream
    end
  end

  # 追加した手順フォームを削除するメソッド
  def remove_step_fields
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.remove("step_#{params[:field_id]}")
      end
    end
  end

  # 手順初期フィールドにて文章をリセットするメソッド
  def reset_step_fields
    @field_id = params[:field_id]
    @recipe = Recipe.new
    @recipe.steps.build
    # 手順フォームの初期フォームを1つ作成する
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_not_exist_recipe
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
      :recipe_image_cache,
      :one_point,
      :description,
      :serving_size,
      recipe_foods_attributes: [:id, :food_id, :quantity, :_destroy],
      steps_attributes: [:id, :description, :_destroy]
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

  # カテゴリーと食材をハッシュに格納するメソッド
  def set_categories_and_foods
    @categories = ['meat', 'fish', 'vegetable', 'seasoning', 'other', 'fruit', 'sweet', 'deli']
    @foods_by_category = @categories.each_with_object({}) do |category, hash|
      # each_with_object({}): ハッシュを生成するメソッド
      hash[category] = Food.where(category: category)
      # 各カテゴリーに対応する食材のリストを取得し、ハッシュに保存
      # Food.where(category: category) :データベースから特定のカテゴリーに属する全ての食材を取得するActiveRecordのクエリ
    end
  end
end