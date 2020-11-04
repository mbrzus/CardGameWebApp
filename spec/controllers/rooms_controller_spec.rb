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
    it 'should call the create! function' do
      # there is no information for Rooms besides auto-generated id
      expect(Room).to receive(:create!).with({})
      post :create, {}
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      room_id = expect(assigns(:room_id))
      expect(response).to redirect_to("/rooms/#{room_id}")
      post :create, {}
    end
  end
end
