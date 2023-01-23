class ItemTagsController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_correct_user, only: [:destroy]

  def destroy
    @item = Item.find(params[:item_id])
    @item_tag = ItemTag.find(params[:id])
    @item_tag.delete
    redirect_to item_path(@item)
  end

  # def ensure_correct_user
  #   @item = Item.find(params[:item_id])
  #   unless @item.user == current_user
  #     redirect_to items_path
  #   end
  # end

end
