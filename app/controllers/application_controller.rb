class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :save_return_url_to_session

  def save_return_url_to_session
    return if !request.get? || request.xhr? || devise_controller?
    store_location_for(:user, request.fullpath)
  end
end
