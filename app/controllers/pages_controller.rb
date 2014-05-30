class PagesController < ApplicationController

  require 'pry'

  before_filter :parse_tree


  def open
    if @tree.empty?
      @pages = Page.all
    else
      @page = Page.where("tree ~ '#{@tree}'").first
      raise Page::NotFound unless @page
      @pages = Page.where("tree ~ '#{@tree}.*{1,}'")
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
    @page = Page.where("tree ~ '#{@tree}'").first
    raise Page::NotFound unless @page

    if request.post?
      page = @page.change_name(params[:name])
      redirect_to :back and return unless page
      redirect_to page.uri
    else  
      @retpath = "/#{params[:tree]}/edit"
    end
  end


  private

  def parse_tree
    @tree = params[:tree].to_s.scan(/[\p{Alnum}_]+/).join('.')
  end

end
