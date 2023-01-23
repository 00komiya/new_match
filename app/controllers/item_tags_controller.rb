class ItemTagsController < ApplicationController
  before_action :authenticate_user!
  # before_action :ensure_correct_user, only: [:destroy]

  def destroy
    @item = Item.find(params[:item_id])
    @item_tag = ItemTag.find(params[:id])
    # if @item_tag.user == current_user
      @item_tag.delete
      redirect_to item_path(@item)
    # else
    #   redirect_to items_path
    # end
  end

  # def ensure_correct_user
  #   @item_tag = ItemTag.find(params[:id])
  #   unless @item_tag.user == current_user
  #     redirect_to items_path
  #   end
  # end

end
