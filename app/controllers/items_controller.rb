class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @item = Item.new
    @tags = Tag.all
  end

  def create
    @tags = Tag.all
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    tag_list = params[:item][:tag_name].delete(" ").split(',')
    if @item.save
      @item.save_tags(tag_list)
      redirect_to items_path, notice: "投稿に成功しました。"
    else
      render :new
    end
  end

  def index
    @tags = Tag.all
    # tag_idに値が入っていたらtag_idで検索する
    items = Item.eager_load(:user).left_joins(:tags).all.distinct
    @items = items.where('users.is_deleted = ?', false)
    if params[:tag_id].present?
      @items = @items.where(tags: {id: params[:tag_id]})
    end

    if params[:latest]
      @items = @items.latest.page(params[:page])
    elsif params[:old]
      @items = @items.old.page(params[:page])
    else
      @items = @items.order(created_at: "DESC").page(params[:page])
    end
  end

  def show
    @item = Item.find(params[:id])
    @item_comments = @item.item_comments.eager_load(:user).where('users.is_deleted = ?', false)
    @item_comment = ItemComment.new
    @tags = Tag.all
  end

  def update
    tag_list = params[:item][:tag_name].delete(" ").split(',')
    if@item.update(item_params)
      @item.save_tags(tag_list)
      redirect_to item_path(@item), notice: "編集が保存されました。"
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "投稿を削除しました。"
  end


  private

  def item_params
    params.require(:item).permit(:image, :name, :shop_name, :introduction)
  end

  def ensure_correct_user
    @tags = Tag.all
    @item = Item.find(params[:id])
    unless @item.user == current_user
      redirect_to items_path
    end
  end

end