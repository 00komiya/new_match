class ItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @item = Item.new
    @tags = Tag.all
  end

  def create
    @tags = Tag.all
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    tag_list = params[:item][:tag_name].split(',')
    if @item.save
      @item.save_tags(tag_list)
      redirect_to items_path, notice: "投稿に成功しました"
    else
      render :new, notice: "投稿に失敗しました"
    end
  end

  def index
    @tags = Tag.all
    # tag_idに値が入っていたらtag_idで検索する
    @items = Item.left_joins(:tags).all.distinct
    if params[:tag_id].present?
      @items = @items.where(tags: {id: params[:tag_id]})
    end

    # 検索結果からページネーションと並び替えを行う
    if params[:latest]
      @items = @items.latest.page(params[:page])
    elsif params[:old]
      @items = @items.old.page(params[:page])
    else
      @items = @items.order("created_at DESC").page(params[:page])
    end
  end

  def show
    @item = Item.find(params[:id])
    @item_comment = ItemComment.new
    @tags = Tag.all
  end

  def edit
    @tags = Tag.all
    @item = Item.find(params[:id])
    if @item.user == current_user
      render :edit
    else
      redirect_to items_path
    end
  end

  def update
    @tags = Tag.all
    @item = Item.find(params[:id])
    tag_list = params[:item][:tag_name].split(',')
    if@item.update(item_params)
      @item.save_tags(tag_list)
      redirect_to item_path(@item), notice: "編集が保存されました"
    else
      render :edit, notice: "編集に失敗しました"
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path, notice: "投稿を削除しました"
  end


  private

  def item_params
    params.require(:item).permit(:image, :name, :shop_name, :introduction)
  end

end