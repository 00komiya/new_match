class Admin::TagsController < ApplicationController
    before_action :authenticate_admin!

    def destroy
      Tag.find(params[:id]).destroy
      redirect_to request.referer, notice: "削除に成功しました"
    end
end
