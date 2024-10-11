class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :profile]

  def show
    @user = User.find(params[:id])
    @user_recipes = @user.recipes.page(params[:recipes_page]).per(8)
    @yummy_notifications = @user.notifications.where(action_type: 'yummy').order(created_at: :desc).page(params[:yummy_page]).per(5)
    @comment_notifications = @user.notifications.where(action_type: 'comment').order(created_at: :desc).page(params[:comment_page]).per(5)
  end

  def profile
    @user = User.find(params[:id])
    @recipes = @user.recipes.page(params[:recipes_page]).per(8)
  end
end
