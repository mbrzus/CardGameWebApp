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
      post :create, {}
      expect(Room.count).to be > room_count
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      post :create, {}
      room_id = assigns(:room_id)
      expect(response).to redirect_to(room_path(:id => room_id))
    end
  end
end
