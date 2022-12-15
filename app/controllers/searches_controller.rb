class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'item'
      @records = Item.search_for(@content, @method).page(params[:page])
    elsif @model == 'user'
      @records = User.search_for(@content, @method)
    elsif @model == 'tag'
      @records = Tag.search_items_for(@content, @method).page(params[:page])
    end
  end
end
