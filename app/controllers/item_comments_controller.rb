class ItemCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @item = Item.find(params[:item_id])
    @item_comments = @item.item_comments.eager_load(:user).where('users.is_deleted = ?', false)
    @comment = current_user.item_comments.new(item_comment_params)
    @comment.item_id = params[:item_id]
    @comment.save
    @item_comment = ItemComment.new
    @comment.item.create_notification_comment!(current_user, @comment.id)
  end

  def destroy
    ItemComment.find_by(id: params[:id], item_id: params[:item_id]).destroy
    @item = Item.find(params[:item_id])
    @item_comments = @item.item_comments.eager_load(:user).where('users.is_deleted = ?', false)
    @item_comment = ItemComment.new(item_id: params[:item_id])
  end

  private

  def item_comment_params
    params.require(:item_comment).permit(:comment)
  end

  def ensure_correct_user
    @item_commment = ItemComment.find(params[:id])
    unless @item_comment.user == current_user
      redirect_to items_path
    end
  end

end
