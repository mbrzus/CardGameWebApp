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

describe AccountsController do
  describe 'creating account' do
    before :each do
      @account = Account.create!(name: 'valid', username: 'valid', email: 'valid@gmail.com', password: 'valid123!!')
    end
    it 'should create a flash message if a username already exists' do
      post :create, account: { name: 'valid', username: 'valid', email: 'test@gmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Username has already been taken')
    end
    it 'should redirect you to the login page if account is created successfully' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(subject).to redirect_to login_path
    end
    it 'should create a flash message if an account is created successfully' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Account created! Please login to continue')
    end
    it 'should keep you on the signup page if the account is invalid' do
      post :create, account: { name: 'test', username: 'valid', email: 'test@gmail.com', password: 'valid123!!' }
      expect(subject).to redirect_to signup_path
    end
    it 'should create a new account if the account is valid' do
      post :create, account: { name: 'test', username: 'testusername', email: 'test@gmail.com', password: 'valid123!!' }
      expect(Account.find_by_username('testusername').username).to eq('testusername')
    end
    it 'should create flash message if the email is an invalid address' do
      post :create, account: { name: 'test', username: 'test', email: 'testgmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Email must be a valid address')
    end
    it 'should render the new template when a user tries to signup' do
      get :new
      expect(response).to render_template('new')
    end
  end
end
#