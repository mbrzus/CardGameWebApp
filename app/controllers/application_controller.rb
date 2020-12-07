class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  @current_user

  def set_current_user
    @current_user ||= session[:session_token] && Account.find_by_session_token(session[:session_token])
    flash[:notice] = 'Please login before using our application' unless @current_user
    redirect_to '/login' and return unless @current_user
  end

  def check_room_exists
    token = session[:room_token]
    room = Room.find_by(room_token: token)
    if room.nil?
      flash[:notice] = 'This room has ended. Thank you for playing!'
      redirect_to rooms_path
    end
  end

end
