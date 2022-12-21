class ItemTagsController < ApplicationController
  def destroy
    @item = Item.find(params[:item_id])
    @item_tag = ItemTag.find(params[:id])
    @item_tag.delete
    redirect_to item_path(@item)
  end
end
