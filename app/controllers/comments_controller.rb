class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to comment.recipe, success: t('messages.save_success', model: Comment.model_name.human)
    else
      flash.now[:danger] = t('messages.save_failed', model: Comment.model_name.human)
      render 'recipes/show', status: :unprocessable_entity
    end
  end

  def edit
    @comment = Comment.find(params[:id])
      # @comment = viewで使用するため、インスタンス変数に代入
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to comment.recipe, success: t('messages.delete_success', model: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(recipe_id: prams[:recipe_id])
      # .merge(recipe_id: prams[:recipe_id]) :prams[:recipe_id]でURLのidを取得し、recipe_idとして使用
      # ( 送られてきたコメント情報がどのレシピに紐づいているのかを判定するために使用 )
      # .mergeを使用する理由: body(フォームデータ)とrecipe_id(URLパラメータ)を結合するため
      # recipe_idを直接記述しない理由: 直接記述すると、フォームから送られてきたrecipe_idを許可してしまう可能性があるため
  end
end
