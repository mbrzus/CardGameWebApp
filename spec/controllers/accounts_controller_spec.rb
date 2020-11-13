require 'spec_helper'
require 'rails_helper'

describe AccountsController do
  describe 'creating account' do
    before :each do
      Account.create!(name: 'valid', username: 'valid', email: 'valid@gmail.com', password: 'valid123!!')
    end
    it 'should create a flash message if user already exist' do
      allow(Account).to receive(:valid?).and_return(false)
      post :create, account: { name: 'valid', username: 'valid', email: 'test@gmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Username has already been taken')
    end
    it 'should redirect you to the login_page if account is created successfully' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(subject).to redirect_to controller: :sessions, action: :new
    end
    it 'should create a flash message if a user created successfully' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Account created! Please login to continue')
    end
    it 'should keep you on sign_up page if passwords do not match' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(subject).to redirect_to signup_path
    end
    it 'should keep you on sign_up page if user already exist' do
      post :create, account: { name: 'test', username: 'test', email: 'test@gmail.com', password: 'valid123!!' }
      expect(subject).to redirect_to sign_up_path
    end
    it 'should create a new account if all validations pass' do
      post :create, account: { name: 'test', username: 'testusername', email: 'test@gmail.com', password: 'valid123!!' }
      expect(Account.find_by_username('testusername').username).to eq('testusername')
    end
    it 'should create flash message if E-mail is invalid' do
      allow(Account).to receive(:valid?).and_return(false)
      post :create, account: { name: 'test', username: 'test', email: 'testgmail.com', password: 'valid123!!' }
      expect(flash[:notice]).to eq('Email must be a valid address')
    end
  end
end
