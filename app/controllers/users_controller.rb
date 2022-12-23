class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :update,]

  def index
    @users = User.where(is_deleted: false).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    if params[:latest]
      @items = @user.items.latest.page(params[:page])
    elsif params[:old]
      @items = @user.items.old.page(params[:page])
    else
      @items = @user.items.order("created_at DESC").page(params[:page])
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user) , notice: "更新が完了しました。"
    else
      render "edit"
    end
  end

  def quit
    @user = current_user
  end

  def out
    current_user.update(is_deleted: true)
    sign_out
    redirect_to root_path , notice: "退会が完了しました。またのご利用をお待ちしております。"
  end

  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:item_id)
    @like_items = Item.find(likes)
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :age, :sex, :address)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
