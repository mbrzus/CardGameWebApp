class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  @current_room

  def set_current_room
    @current_room ||= session[:room_token] && Room.find_by_room_token(session[:room_token])
    redirect_to '/rooms' and return unless @current_room
  end
end
