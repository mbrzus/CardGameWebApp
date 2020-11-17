require 'spec_helper'
require 'rails_helper'

# monkey patch method found by class member on teams
if RUBY_VERSION >= '2.6.0'
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
    puts 'Monkeypatch for ActionController::TestResponse no longer needed'
  end
end

describe RoomsController do
  before :each do
    @account = Account.create!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!')
    session[:session_token] = @account.session_token
  end
  describe 'Creating a new Room' do
    it 'should create a new room in the database' do
      # there is no information for Rooms besides auto-generated id
      room_count = Room.count
      post :create, room: { room_name: 'Test Name', public: 1 }
      expect(Room.count).to be > room_count
    end
    it 'should create a dealer player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, room: { room_name: 'Test Name', public: 1 }
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'dealer', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should create a sink player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, room: { name: 'Test Name', public: 1 }
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'sink', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      post :create, room: { room_name: 'Test Name', public: 1 }
      room_id = assigns(:room_id)
      room = Room.find(room_id)
      token = room.room_token
      expect(response).to redirect_to(room_path(:id => token))
    end
  end

  describe 'Joining a room' do
    it 'should redirect the user to a page where they can create a new user (if the user has not provided a name)' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      session[:room_token] = token
      post :show, { id: token }
      expect(response).to redirect_to('/players/new')
    end
    it 'should redirect the user to the room page (if the session exists)' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      session[:room_token] = token
      post :show, { :id => token }, { :room_to_join => '1', '1' => Player.create(:name => 'Daniel', :room => Room.find(1)) }
      expect(response).to_not redirect_to('/players/new')
    end
    it '(the join_room action) should direct the user to the show action' do
      room = Room.find(1)
      token = room.room_token
      post :join_room, room: { room_token: token }
      expect(response).to redirect_to("/rooms/#{token}")
    end
    it 'should redirect the user to the index page' do
      post :join_room, room: { room_token: 'dsafsadgljsadf' }
      expect(response).to redirect_to('/rooms')
    end
    it 'should create a flash message to notify the user if the room does not exist' do
      post :join_room, room: { room_token: 'dsafsadgljsadf' }
      expect(flash[:notice]).to eq('No room exists with code: dsafsadgljsadf!')
    end
  end

  describe 'Delete a room' do
    before :each do
      session[:room_token] = Room.create_room!(name: 'name', public: 1).room_token
    end
    it 'should redirect the user home page' do
      # there is no information for Rooms besides auto-generated id

      post :destroy, { id: session[:room_token] }
      expect(response).to redirect_to('/rooms')
    end
    it 'should delete room from database Room table' do
      # there is no information for Rooms besides auto-generated id
      room = Room.where(room_token: session[:room_token])
      post :destroy, { id: session[:room_token] }
      expect(room.length).to be(0)
    end
    it 'should delete cards associated with the room' do
      # there is no information for Rooms besides auto-generated id
      room = Room.where(room_token: session[:room_token])
      post :destroy, { id: session[:room_token] }
      cards = Card.where(room: room)
      expect(cards.length).to be(0)
    end
    it 'should delete players associated with the room' do
      # there is no information for Rooms besides auto-generated id
      room = Room.where(room_token: session[:room_token])
      post :destroy, { id: session[:room_token] }
      players = Player.where(room: room)
      expect(players.length).to be(0)
    end
  end

  describe 'Reset a room' do
    it 'should redirect the user to the same page' do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      token = room.room_token
      post :reset, { :id => token }, { :room_to_join => '1' }
      expect(response).to redirect_to("/rooms/#{token}")
    end
    it "should give all the cards in the room to the room's dealer" do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      player = Player.where(room: room, name: 'Ted')[0]
      Card.create!({:room => room, :value => 'A', :suit => 'spades', :player => player, :image_url => 'AS.png'})
      post :reset, { :id => room.room_token }, { :room_to_join => '1' }
      cards = Card.where(room: room)
      dealer = Player.where(room: room, name: 'dealer')[0]
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

  describe 'Get the public rooms' do
    it 'should get a list of public rooms' do
      # assume that the test database has been seeded
      post :index, { }, { }
      public_rooms = assigns(:public_rooms_information)
      # since the test database is seeded, there will be at least one result
      expect(public_rooms.length).to_not eq(0)
      public_room = public_rooms[0]
      expect(public_room).to have_key(:room_name)
      expect(public_room).to have_key(:room_id)
      expect(public_room).to have_key(:player_names_list)
    end
  end
end
