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

describe RoomsController do
  describe 'Creating a new Room' do
    it 'should create a new room in the database' do
      # there is no information for Rooms besides auto-generated id
      room_count = Room.count
      post :create, { :room_name => { "room_name" => "Test Name" }, :public => { "public" => 1 } }
      expect(Room.count).to be > room_count
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      post :create, { :room_name => { "room_name" => "Test Name" }, :public => { "public" => 1 } }
      room_id = assigns(:room_id)
      expect(response).to redirect_to(room_path(:id => room_id))
    end
  end

  describe 'Joining a room' do
    it 'should redirect the user to a page where they can create a new user (if no session is set)' do
      # there is no information for Rooms besides auto-generated id
      post :show, { :id => "1" }, { :room_to_join => "1" }
      expect(response).to redirect_to('/players/new')
    end
    it 'should redirect the user to the room page (if the session exists)' do
      # there is no information for Rooms besides auto-generated id
      post :show, { :id => "1" }, { :room_to_join => "1", "1" => Player.create(:name => "Daniel", :room => Room.find(1)) }
      expect(response).to_not redirect_to('/players/new')
    end
    it '(the join_room action) should direct the user to the show action' do
      post :join_room, { :room_id => { "room_id" => "1"} }, { }
      expect(response).to redirect_to('/rooms/1')
    end
  end
end
