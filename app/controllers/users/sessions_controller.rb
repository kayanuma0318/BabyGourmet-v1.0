# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new; end

  # POST /resource/sign_in
  def create
    @user = User.find_by(email: params[:session][:email])
    # scope: :sessionで指定したパラメータを取得
    if @user&&@user.valid_password?(params[:session][:password])
      # @user: ユーザーの存在を確認し、devise標準メソッドvalid_password?で入力値とDBのパスワードを比較
      sign_in(@user)
      redirect_to root_path, success: t('flash.logged_in')
    else
      flash.now[:danger] = t('flash.login_failed')
      render 'new', status: :unprocessable_entity
    end
  end

  # DELETE /resource/sign_out
  def destroy
    sign_out
    redirect_to root_path, info: t('flash.logout')
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
