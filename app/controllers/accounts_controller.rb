class AccountsController < ApplicationController

  before_filter :set_current_user, except: %i[new create]

  def account_params
    params.require(:account).permit(:name, :username, :email, :password)
  end

  def new
    redirect_to rooms_path if @current_user
  end

  def create
    account_params[:email].downcase!
    account = Account.new(account_params)
    flash[:notice] = account.valid? ? 'Account created! Please login to continue' : account.error_message
    redirect_to signup_path and return unless account.valid?

    Account.create_account!(account_params)
    redirect_to login_path
  end

end
