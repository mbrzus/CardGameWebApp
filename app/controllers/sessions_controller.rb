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

  def create_omniauth
    auth = request.env['omniauth.auth']
    account = Account.find_by_provider_and_uid(auth['provider'], auth['uid']) || Account.create_from_omniauth!(auth)
    session[:session_token] = account.session_token
    username = account.oauth_username
    if username.include? "twitter"
      username = username.sub /@twitter/, ''
    elsif username.include? "google_oauth"
      username = username.sub /@google_oauth2/, ''
    end
    flash[:notice] = "Welcome #{username}"
    redirect_to rooms_path
  end

  def destroy
    session[:session_token] = nil
    session.clear
    flash[:notice] = 'Successfully logged out.'
    redirect_to login_path
  end

end

