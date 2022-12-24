class ItemCommentsController < ApplicationController
  before_action :ensure_guest_user, only: [:create]

  def create
    @item_comments = ItemComment.eager_load(:user).where('users.is_deleted = ?', false)
    @comment = current_user.item_comments.new(item_comment_params)
    @comment.item_id = params[:item_id]
    @comment.save
    @item_comment = ItemComment.new
    # redirect_to request.referer 非同期処理

    @comment.item.create_notification_comment!(current_user, @comment.id)
  end

  def destroy
    ItemComment.find_by(id: params[:id], item_id: params[:item_id]).destroy
    @item_comments = ItemComment.eager_load(:user).where('users.is_deleted = ?', false)
    @item_comment = ItemComment.new(item_id: params[:item_id])
    # redirect_to request.referer 非同期処理
  end

  private

  def item_comment_params
    params.require(:item_comment).permit(:comment)
  end

  def ensure_guest_user
    if current_user.name == "guestuser"
      redirect_to user_path(current_user) , notice: "ゲストユーザーです。コメントするには本登録をお願いします。"
    end
  end
end
