class SessionsController < ApplicationController

  def session_params
    params.require(:account).permit(:username, :password)
  end

  def create
    account = Account.find_by(username: session_params[:username]).try(:authenticate, session_params[:password])
    flash[:notice] = account ? "Welcome #{account.username}!" : 'Incorrect username or password'
    redirect_to login_path and return unless account

    session[:session_token] = account.session_token
    redirect_to rooms_path
  end

  def destroy
    session[:session_token] = nil
    session.clear
    flash[:notice] = 'Successfully logged out.'
    redirect_to login_path
  end

end

