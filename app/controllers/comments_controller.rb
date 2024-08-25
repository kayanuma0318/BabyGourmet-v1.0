class CommentsController < ApplicationController
  before_action :authenticate_user!
    # ログインしていない場合、ログインページにリダイレクト
  before_action :set_comment, only: %i[edit update destroy]
    # ログイン中のユーザーのコメントを取得するメソッド

  def create
    @recipe = Recipe.find(params[:recipe_id])
      # URLのパラメータからrecipe_idを取得し、IDの同じレシピを取得
      # コメントを投稿するレシピを取得(コメントとレシピの関連付けが明確になる)
    @comment = current_user.comments.build(comment_params)
      # 新しいコメントを作成し、ログイン中のユーザーをコメントの投稿者として設定
      # comment_paramsでフォームから送られてきたコメント情報を取得
    @comment.recipe = @recipe
      # 先ほど取得したレシピをコメントに紐付ける

    respond_to do |format|
      if @comment.save
        format.turbo_stream
          # turbo_streamフォーマットのリクエストの場合
          # create.turbo_stream.erbへリダイレクト
      else
        format.turbo_stream { render :edit, status: :unprocessable_entity }
          # turbo_streamフォーマットのリクエストの場合
          # create.turbo_stream.erbへリダイレクト
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(edit_params)
        format.turbo_stream
        # update.turbo_stream.erbへリダイレクト
      else
        format.turbo_stream
        # update.turbo_stream.erbへリダイレクト
      end
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream
      # destroy.turbo_stream.erbへリダイレクト
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(recipe_id: params[:recipe_id])
      # .merge(recipe_id: prams[:recipe_id]) :prams[:recipe_id]でURLのidを取得し、recipe_idとして使用
      # ( 送られてきたコメント情報がどのレシピに紐づいているのかを判定するために使用 )
      # .mergeを使用する理由: body(フォームデータ)とrecipe_id(URLパラメータ)を結合するため
      # recipe_idを直接記述しない理由: 直接記述すると、フォームから送られてきたrecipe_idを許可してしまう可能性があるため
  end

  def edit_params
    params.require(:comment).permit(:body)
      # 編集では既にレシピIDが設定されているため、recipe_idを許可する必要がない
      # 上記のように(comment_params)許可するとバリデーションエラーとなる（エラー現象:Recipeを入力してください。）
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
    # ログイン中のユーザーがコメントしたコメントを取得
  end
end
