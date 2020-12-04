class AccountsController < ApplicationController

  before_filter :set_current_user, except: %i[new create]

  def account_params
    params.require(:account).permit(:username, :email, :password)
  end

  def new
    session[:update] = false

    redirect_to rooms_path if @current_user
  end

  def create
    account = Account.new(account_params)
    flash[:notice] = account.valid? ? 'Account created! Please login to continue' : account.error_message
    redirect_to signup_path and return unless account.valid?

    Account.create_account!(account_params)
    session[:update] = true
    redirect_to login_path
  end

end
