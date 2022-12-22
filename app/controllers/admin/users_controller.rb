class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def show
    @user = User.find(params[:id])
    @items = @user.items.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "変更の保存に成功しました"
    else
      render "edit"
    end
  end

  # 退会ステータスのみ変更
  def user_params
    params.require(:user).permit(:is_deleted)
  end
end
