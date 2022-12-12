class ItemCommentsController < ApplicationController
  def create
    @item = Item.find(params[:item_id])
    @comment = current_user.item_comments.new(item_comment_params)
    @comment.item_id = @item.id
    @comment.save
    redirect_to request.referer
  end

  def destroy
    ItemComment.find_by(id: params[:id], item_id: params[:item_id]).destroy
    redirect_to request.referer
  end

  private

  def item_comment_params
    params.require(:item_comment).permit(:comment)
  end

end
