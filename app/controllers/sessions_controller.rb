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
    flash[:notice] = "Welcome #{account.username}"
    redirect_to rooms_path
  end

  def destroy
    session[:session_token] = nil
    flash[:notice] = 'Successfully logged out.'
    redirect_to login_path
  end

end

