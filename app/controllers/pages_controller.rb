class PagesController < ApplicationController

  require 'pry'

  before_filter :parse_tree


  def open
    # binding.pry

    if @tree.empty?
      @pages = Page.all
    else
      @pages = Page.where("tree ~ '#{@tree}.*'")
    end
  end

  def add
    if request.post?
      page = Page.add(params[:name], @tree)
      redirect_to :back and return unless page
      redirect_to page.uri
    else
      @retpath = (params[:tree].present? ? "/#{params[:tree]}/add" : "/add")
    end
  end

  def edit
    render text: 'edit'
  end


  private

  def parse_tree
    @tree = params[:tree].to_s.scan(/[\p{Alnum}_]+/).join('.')
  end

end
