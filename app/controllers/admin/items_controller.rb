class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.all.page(params[:page]).per(10)
    @tags = Tag.all
  end

  def show
    @item = Item.find(params[:id])

  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path, notice: "削除に成功しました"
  end

end
