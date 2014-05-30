class ApplicationController < ActionController::Base

  protect_from_forgery

  rescue_from Page::BadRequest, with: :bad_request
  rescue_from Page::NotFound, with: :not_found
  rescue_from Page::TreeTooLarge, with: :uri_too_large
  

  protected

  def bad_request
    redirect_to '/400'
  end

  def not_found
    redirect_to '/404'
  end

  def uri_too_large
    redirect_to '/414'
  end
end
