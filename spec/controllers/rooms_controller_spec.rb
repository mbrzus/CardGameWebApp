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
    it 'should create a dealer player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, {}
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'dealer', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should create a sink player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, {}
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'sink', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      post :create, {}
      room_id = assigns(:room_id)
      room = Room.find(room_id)
      token = room.room_token
      expect(response).to redirect_to(room_path(:id => token))
    end
  end

  describe 'Joining a room' do
    it 'should redirect the user to a page where they can create a new user (if no session is set)' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :show, { :id => token }, { :room_to_join => "1" }
      expect(response).to redirect_to('/players/new')
    end
    it 'should redirect the user to the room page (if the session exists)' do
      # there is no information for Rooms besides auto-generated id
      post :show, { :id => "1" }, { :room_to_join => "1", "1" => Player.create(:name => "Daniel", :room => Room.find(1)) }
      expect(response).to_not redirect_to('/players/new')
    end
    it '(the join_room action) should direct the user to the show action' do
      room = Room.find(1)
      token = room.room_token
      post :join_room, { :room_id => { "room_id" => "1"} }, { }
      expect(response).to redirect_to("/rooms/#{token}")
    end
  end

  describe 'Delete a room' do
    it 'should redirect the user home page' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :destroy, { :id => token }, { :room_to_join => 1 }
      expect(response).to redirect_to('/rooms')
    end
    it 'should delete room from database Room table' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :destroy, { :id => token }, { :room_to_join => "1" }
      room = Room.where(id: 1)
      expect(room.length).to be(0)
    end
    it 'should delete cards associated with the room' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :destroy, { :id => token }, { :room_to_join => "1" }
      cards = Card.where(room: room)
      expect(cards.length).to be(0)
    end
    it 'should delete players associated with the room' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :destroy, { :id => token }, { :room_to_join => "1" }
      players = Player.where(room: room)
      expect(players.length).to be(0)
    end
  end

  describe 'Reset a room' do
    it 'should redirect the user to the same page' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :reset, { :id => token }, { :room_to_join => "1" }
      expect(response).to redirect_to("/rooms/#{token}")
    end
    it "should give all the cards in the room to the room's dealer" do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      player = Player.where(room: room, name: "Ted")[0]
      Card.create!({:room => room, :value => 'A', :suit => 'spades', :player => player, :image_url => 'AS.png'})
      post :reset, { :id => room.room_token }, { :room_to_join => "1" }
      cards = Card.where(room: room)
      dealer = Player.where(room: room, name: "dealer")[0]
      helper = TRUE
      cards.each do |card|
        owned_id = card.player_id
        if owned_id != dealer.id
          helper = FALSE
        end
      end
      expect(helper).to be(TRUE)
    end
  end
end
