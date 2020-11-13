class SessionsController < ApplicationController

  def session_params
    params.require(:account).permit(:username, :password)
  end

  def create
    account = Account.find_by(username: session_params[:username]).try(:authenticate, session_params[:password])
    if account
      session[:session_token] = account.session_token
      redirect_to rooms_path
    else
      flash[:notice] = 'Incorrect username or password'
      redirect_to login_path
    end
  end

  def destroy
    session[:session_token] = nil
    flash[:notice] = 'Successfully logged out.'
    redirect_to login_path
  end

end

