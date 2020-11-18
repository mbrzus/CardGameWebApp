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


describe PlayersController do
  before :each do
    session[:session_token] = Account.create!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!').session_token
    session[:room_token] = Room.find(1).room_token
  end
  describe 'CRUD Operations when room_token is set in session' do
    # Need to downgrade to Ruby 2.4.4 to run this test
    it 'should call create_or_load' do
      room = Room.find(1)
      fake_results = { :name => "Daniel",
                       :room => room }
      expect(Player).to receive(:create_or_load).with(fake_results)
      post :create, { :player_name => { "name" => "Daniel" } }
    end
    it 'should call redirect to the game page' do
      post :create, { :player_name => { "name" => "Daniel" } }
      expect(response).to redirect_to(room_path(session[:room_token]))
    end



    # Need to downgrade to Ruby 2.4.4 to run this test
    it 'delete player' do

    end

  end
end
