class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    tag_list = params[:item][:tag.name].split(',')
    if @item.save
      @item.save_tags(tag_list)
      redirect_to items_path
    else
      render :new
    end
  end

  def index
    @tags = Tag.all
    if params[:latest]
      @items = Item.latest.page(params[:page])
    elsif params[:old]
      @items = Item.old.page(params[:page])
    else
      @items = Item.order("created_at DESC").page(params[:page])
    end
  end

  def show
    @item = Item.find(params[:id])
    @item_comment = ItemComment.new
    #byebug
  end

  def edit
    @item = Item.find(params[:id])
    if @item.user == current_user
      render :edit
    else
      redirect_to items_path
    end
  end

  def update
    @item = Item.find(params[:id])
    if@item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path
  end


  private

  def item_params
    params.require(:item).permit(:image, :name, :shop_name, :introduction)
  end
end
