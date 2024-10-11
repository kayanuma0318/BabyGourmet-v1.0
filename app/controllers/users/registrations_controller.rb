# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  # POST /resource
  def create
    @user = User.new(sign_up_params)
    if @user.save
      sign_in(@user)
      redirect_to root_path, success: t('flash.welcome')
    else
      flash.now[:danger] = t('flash.signin_failed')
      render :new, status: :unprocessable_entity
      # status: :unprocessable_entity :HTTPステータスコード422を返す
    end
  end

  # GET /resource/edit
  def edit
    @user = current_user
  end

  # PUT /resource
  def update
    @user = current_user
    if params[:user][:password].present?
      if @user.update_with_password(account_update_params)
        bypass_sign_in(@user)
        redirect_to profile_path, success: 'ユーザー情報とパスワードを更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(account_update_params.except(:current_password, :password, :password_confirmation))
        redirect_to profile_path, success: 'ユーザー情報を更新しました'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    redirect_to root_path, success: 'アカウントを削除しました'
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :avatar_cache)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_cache)
  end
end
