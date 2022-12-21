class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'item'
      @records = Item.search_for(@content, @method).page(params[:page])
    elsif @model == 'user'
      @records = User.search_for(@content, @method)
    elsif @model == 'tag'
      @records = Item.left_joins(:tags).where(tags: {id: @content})
      @content = Tag.find(@content).name
    end
  end
end
