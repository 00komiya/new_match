class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'item'
      @records = Item.search_for(@content, @method).page(params[:page])
    else @model == 'user'
      @records = User.search_for(@content, @method)
    end
  end
end
