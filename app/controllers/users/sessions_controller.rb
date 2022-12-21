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
  ## 【処理内容1】 入力されたnameアカウントを1件取得
    @user = User.find_by(name: params[:user][:name])
  ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@user
  ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別
    if @user.valid_password?(params[:user][:password]) && @user.is_deleted = true
  ## 【処理内容3】
      redirect_to new_user_registration_path, notice: "退会済みのアカウントです"
    end
  end
end