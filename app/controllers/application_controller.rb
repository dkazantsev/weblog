class ApplicationController < ActionController::Base

  protect_from_forgery

  rescue_from Page::WrongRequest, with: :deny_access
  

  protected

  def deny_access
    redirect_to '/500'
  end
end
