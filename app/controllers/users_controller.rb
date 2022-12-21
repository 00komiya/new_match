class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :update]

  def index
    @users = User.all.page(params[:page]).per(10)
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
    @user = User.find(params[:id])
    if @user == current_user
        render "edit"
    else
      redirect_to user_path(current_user)
    end
  end

   def update
    @user = User.find(params[:id])
   if @user.update(user_params)
    redirect_to user_path(@user) , notice: "プロフィールを更新しました"
   else
     render :edit , notice: "プロフィールの編集に失敗しました"
   end
  end

  def quit
    @user = current_user
  end

  def out
    current_user.update
    sign_out
    redirect_to root_path
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

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません"
    end
  end
end
