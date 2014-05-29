class PagesController < ApplicationController

  def open
    render text: 'open'
  end

  def add
    puts "/" + params[:tree]
    render text: 'add'
  end

  def edit
    render text: 'edit'
  end

end
