require 'spec_helper'
require 'rails_helper'

# monkey patch method found by class member on teams
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe SessionsController do
  describe 'logging into the application' do
    before :each do
      Account.create_account!(username: 'test', email: 'test@gmail.com', password: 'test123!!')
      @account = Account.create_account!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!')
    end
    it 'should redirect you to the login page if the password is incorrect' do
      post :create, { account: {username: 'valid', password: 'incorrect'} }
      expect(subject).to redirect_to login_path
    end
    it 'should redirect you to the login page if the username is incorrect' do
      post :create, { account: {username: 'valid', password: 'test123!!'} }
      expect(subject).to redirect_to login_path
    end
    it 'should create a flash message if unable to find user_id and password combination' do
      post :create, { account: {username: 'incorrect', password: 'valid'} }
      expect(flash[:notice]).to eq('Incorrect username or password')
    end
    it 'should redirect you to the rooms page if successful login' do
      post :create, { account: {username: 'valid', password: 'valid123!!'} }
      expect(subject).to redirect_to rooms_path
    end
    it 'sets the session_token in the session hash' do
      post :create, { account: {username: 'valid', password: 'valid123!!'} }
      expect(session[:session_token]).to eq(@account.session_token)
    end
  end
  describe 'logging in with twitter' do
    before :each do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end
    it 'should redirect you to the jobs_index page if successful login' do
      post :create_omniauth, provider: :twitter
      expect(subject).to redirect_to rooms_path
    end
    it 'should create a flash message if a successful login' do
      post :create_omniauth, provider: :twitter
      expect(flash[:notice]).to eq('Welcome mockuser@twitter')
    end
  end
  describe 'Creating a session through google' do
    before :each do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end
    it 'should redirect you to the jobs_index page if successful login' do
      post :create_omniauth, provider: :google_oauth2
      expect(subject).to redirect_to rooms_path
    end
    it 'should create a flash message if a successful login' do
      post :create_omniauth, provider: :google_oauth2
      expect(flash[:notice]).to eq('Welcome mockuser@gmail.com@google_oauth2')
    end
  end
  describe 'destroying session (logging out)' do
    it 'should set the session_token to nil when a user logs out' do
      post :destroy
      expect(session[:session_token]).to be_nil
    end
    it 'should create a flash message reflecting a successful log out' do
      post :destroy
      expect(flash[:notice]).to eq('Successfully logged out.')
    end
    it 'should redirect the user to the login page' do
      post :destroy
      expect(subject).to redirect_to login_path
    end
  end
end
