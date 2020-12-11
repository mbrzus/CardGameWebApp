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
      post :create, room: { room_name: 'Test Name', public: 1 }, :cards_to_use => "A-C,A-S,10-D,10-H"
      expect(Room.count).to be > room_count
    end
    it 'should create a dealer player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, room: { room_name: 'Test Name', public: 1 }, :cards_to_use => "A-C,A-S,10-D,10-H"
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'dealer', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should create a sink player associated with this room in the database' do
      # there is no information for Rooms besides auto-generated id
      post :create, room: { name: 'Test Name', public: 1 }, :cards_to_use => "A-C,A-S,10-D,10-H"
      id = assigns(:room_id)
      room = Room.find(id)
      dealer = Player.where(name: 'sink', room: room)
      expect(dealer.length).to be(1)
    end
    it 'should redirect to the show specific room controller' do
      # get the room_id returned by the room creation
      post :create, room: { room_name: 'Test Name', public: 1 }, :cards_to_use => "A-C,A-S,10-D,10-H"
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
    it 'should redirect the user to the index page if the room does not exist' do
      post :join_room, room: { room_token: 'dsafsadgljsadf' }
      expect(response).to redirect_to('/rooms')
    end
    it 'should create a flash message to notify the user if the room does not exist' do
      post :join_room, room: { room_token: 'dsafsadgljsadf' }
      expect(flash[:notice]).to eq('No room exists with code: dsafsadgljsadf!')
    end
    it 'should redirect to the index page when a user tries to enter a room if no room_token is set in the session' do
      session[:room_token] = nil
      post :show, id: Room.find(1).room_token
      expect(response).to redirect_to('/rooms')
    end
    it 'should create a flash message to notify the user to enter a room code to join a room' do
      session[:room_token] = nil
      post :show, id: Room.find(1).room_token
      expect(flash[:notice]).to eq('Please join a room by entering a room code below')
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
    before :each do
      # Ensure the test database includes an initial room with two players other than the dealer and sink
      @room = Room.create_room!(name: 'test', player_limit: 5, public: 1)
      @room.initialize_room("A-D,A-C,A-S,A-H,2-D,2-C,2-S,2-H,3-D,3-C,3-S,3-H,4-D,4-C,4-S,4-H,5-D,5-C,5-S,5-H,
6-D,6-C,6-S,6-H,7-D,7-C,7-S,7-H,8-D,8-C,8-S,8-H,9-D,9-C,9-S,9-H,10-D,10-C,10-S,10-H,J-D,J-C,J-S,J-H,Q-D,Q-C,Q-S,Q-H,K-D,
K-C,K-S,K-H,")
      session[:room_token] = @room.room_token
    end
    it 'should redirect the user to the same page' do
      # there is no information for Rooms besides auto-generated id

      post :reset, { id: @room.room_token }
      expect(response).to redirect_to("/rooms/#{@room.room_token}")
    end
    it "should give all the cards in the room to the room's dealer" do
      # there is no information for Rooms besides auto-generated id
      room = Room.find(1)
      puts room.to_s
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
      expect(public_room).to have_key(:room_token)
      expect(public_room).to have_key(:player_names_list)
    end
  end

  describe 'adding cards to a room' do
    before :each do
      # Ensure the test database includes an initial room with two players other than the dealer and sink
      @room = Room.create_room!(name: 'test', player_limit: 5, public: 1)
      @room.initialize_room("A-D,A-C,A-S,A-H,2-D,2-C,2-S,2-H,3-D,3-C,3-S,3-H,4-D,4-C,4-S,4-H,5-D,5-C,5-S,5-H,
6-D,6-C,6-S,6-H,7-D,7-C,7-S,7-H,8-D,8-C,8-S,8-H,9-D,9-C,9-S,9-H,10-D,10-C,10-S,10-H,J-D,J-C,J-S,J-H,Q-D,Q-C,Q-S,Q-H,K-D,
K-C,K-S,K-H,")
      session[:room_token] = @room.room_token
      session[:room_id] = @room.id
    end
    it 'should redirect the user to the room they created the cards for' do
      post :create_new_deck
      expect(response).to redirect_to("/rooms/#{@room.room_token}")
    end
    it 'should create a flash message that the deck was added' do
      post :create_new_deck
      expect(flash[:notice]).to eq("New card deck created in room #{@room.id}")
    end
  end

  describe 'After game was ended. Other players should be redirect to room path upon any action' do
    before :each do
      session[:room_token] = Room.create_room!(name: 'name', public: 1).room_token
    end
    it 'user should get redirected when trying to reset' do
      # there is no information for Rooms besides auto-generated id
      token = session[:room_token]
      post :destroy, { id: token }
      post :reset, { id: token }
      expect(response).to redirect_to('/rooms')
    end
    it 'user should get redirected when trying to end room' do
      # there is no information for Rooms besides auto-generated id
      token = session[:room_token]
      post :destroy, { id: token }
      post :destroy, { id: token }
      expect(response).to redirect_to('/rooms')
    end
    it 'user should get redirected when trying to create a new deck' do
      # there is no information for Rooms besides auto-generated id
      token = session[:room_token]
      post :destroy, { id: token }
      post :create_new_deck, { id: token }
      expect(response).to redirect_to('/rooms')
    end
  end
end
