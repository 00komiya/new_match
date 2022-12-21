class Admin::ItemCommentsController < ApplicationController
    before_action :authenticate_admin!

    def destroy
      ItemComment.find(params[:id]).destroy
      redirect_to request.referer
    end
end
