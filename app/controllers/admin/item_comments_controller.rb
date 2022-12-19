class Admin::ItemCommentsController < ApplicationController
    before_action :authenticate_admin!
    def destroy
      ItemComment.find_by(id: params[:id], item_id: params[:item_id]).destroy
      @item = Item.find(params[:item_id])
      @item_comment = ItemComment.new
      redirect_to request.referer
    end
end
