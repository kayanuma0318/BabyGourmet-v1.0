class CommentsController < ApplicationController
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
      # リクエストのフォーマット(HTML,turbo_stream)によってレスポンスを分岐
      if @comment.save
        format.turbo_stream
          # turbo_streamフォーマットのリクエストの場合
          # create.turbo_stream.erbをレンダリング、新しいコメントを追加
        format.html { redirect_to recipe_path(@comment.recipe), success: t('messages.save_success', model: Comment.model_name.human) }
          # HTMLフォーマットのリクエストの場合
          # コメントが追加されたレシピ(/recipe/:id)へリダイレクトする
      else
        format.turbo_stream
          # turbo_streamフォーマットのリクエストの場合
          # create.turbo_stream.erbをレンダリング、新しいコメントを追加
        format.html { redirect_to recipe_path(@comment.recipe), danger: t('messages.save_failed', model: Comment.model_name.human) }
          # HTMLフォーマットのリクエストの場合
          # コメントを追加しようとしていたレシピページ(/recipe/:id)へリダイレクトする
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
      # @comment = viewで使用するため、インスタンス変数に代入
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to recipe_path(@comment.recipe), success: t('messages.destroy_success', model: Comment.model_name.human) }
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
end
