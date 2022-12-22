class Users::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'ゲストユーザーでログインしました。'
  end

  protected
  # 退会しているかを判断するメソッド
  def user_state
    @user = User.find_by(name: params[:user][:name])
    return if !@user
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted
      redirect_to new_user_registration_path, notice: "退会済みのアカウントです。再度ご登録をお願い致します。"
    end
  end
end