require 'spec_helper'
require 'rails_helper'

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

describe CardsController do
  before :each do
    # Ensure the test database includes an initial room with two players other than the dealer and sink
    @room = Room.create_room!(name: 'name', public: 1)
    @player1 = Player.create!({ name: 'player1', room: @room })
    @player2 = Player.create!({ name: 'player2', room: @room })
    @players = Player.where(room_id: @room_id)
    # Initialize the session variables we've been working to ensure tests run like a player is logged in and has joined
    # a room.
    session[:session_token] = Account.create!(username: 'valid', email: 'valid@gmail.com',
                                              password: 'valid123!!').session_token
    session[:room_token] = @room.room_token
    session[:room_id] = @room.id
    session[@room.id] = Player.create_or_load({ name: 'current user', room: @room })
  end
  describe 'rendering the view to draw cards' do
    before :each do
      post :draw_cards
    end
    it 'should render the view to draw cards for the draw_cards action' do
      expect(response).to render_template('draw_cards')
    end
    it 'should render a view that includes the name of each player (including dealer/sink) when dealing cards' do
      @players.each do |player|
        expect(response.body).to include(player.name)
      end
    end
  end
  describe 'rendering the view to give cards' do
    before :each do
      post :give_cards, room_id: @room.id
    end
    it 'should render the view to give cards for the draw_cards action' do
      expect(response).to render_template('give_cards')
    end
    it 'should render a page that includes the name of each player in the room (including dealer and sink)' do
      @players.each do |player|
        expect(response.body).to include(player.name)
      end
    end
  end

  before :each do
    @selected_players = {}
    @selected_cards = {}
    @dealer = Player.find_by(room_id: @room.id, name: 'dealer')
  end
  describe 'transactions between dealer and players' do
    it 'should allow players to draw cards from the dealer' do
      player_cards_count = Card.where(room_id: @room.id, player_id: @player1.id).length
      dealer_cards_count = Card.where(room_id: @room.id, player_id: @dealer.id).length
      @selected_players[@player1.id] = 1
      post :draw_cards_from_dealer, quantity: { quantity: 5 }, players_selected: @selected_players
      expect(Card.where(room_id: @room.id, player_id: @player1.id).length).to eq(player_cards_count + 5)
      expect(Card.where(room_id: @room.id, player_id: @dealer.id).length).to eq(dealer_cards_count - 5)
    end
    it 'should allow multiple players to be dealt cards at the same time' do
      count_hash = {}
      @players.each do |player|
        count_hash[player.id] = Card.where(room_id: @room.id, player_id: @player1.id).length
        @selected_players[player.id] = 1 unless @player.id == @dealer.id
      end
      post :draw_cards_from_dealer, quantity: { quantity: 5 }, players_selected: @selected_players
      @players.each do |player|
        expect(Card.where(room_id: @room.id, player_id: player.id).length).to eq(count_hash[player.id] + 5) unless @player.id == @dealer.id
      end
    end
    it 'should flash a notice that cards were successfully to dealt' do
      @selected_players[@player1.id] = 1
      post :draw_cards_from_dealer, quantity: { quantity: 5 }, players_selected: @selected_players
      expect(flash[:notice]).to eq("Successfully dealt 5 cards to #{@player1.name}, ")
    end
    it 'should flash a warning that the quantity of cards must be a positive number for an invalid quantity input' do
      @selected_players[@player1.id] = 1
      post :draw_cards_from_dealer, quantity: { quantity: '' }, players_selected: @selected_players
      expect(flash[:warning]).to eq('ERROR: Invalid input. Must input a positive, numeric value to deal.')
    end
    it "should flash a warning the cards can't be dealt when the deck has less cards than the quantity requested" do
      @selected_players[@player1.id] = 1
      post :draw_cards_from_dealer, quantity: { quantity: 55 }, players_selected: @selected_players
      expect(flash[:warning]).to eq('Dealer can not deal the requested number of cards')
    end
    it "should flash a warning when no players are selected" do
      post :draw_cards_from_dealer, quantity: { quantity: 5 }
      expect(flash[:warning]).to eq('ERROR: Invalid input. Must choose atleast 1 player to deal to.')
    end
  end
  describe 'transactions between players' do
    before :each do
      # Draw 5 cards into the current users hand to give away
      post :draw_cards_from_dealer, quantity: { quantity: 5 }, players_selected: { "#{session[@room.id].id}": 1 }
      # Arbitrarily select the first three cards to give away
      @cards_to_give = Card.where(room_id: @room.id, player_id: session[@room.id].id)
    end
    it 'should allow a player to give their cards to another player' do
      user_id = session[@room.id].id
      user_cards_count = @cards_to_give.length
      recipient_cards_count = Card.where(room_id: @room.id, player_id: @player1.id).length
      @selected_players[@player1.id] = 1
      @cards_to_give.each { |card| @selected_cards[card.id] = 1 if @selected_cards.length < 3 }
      post :give_cards_transaction, cards_selected: @selected_cards, players_selected: @selected_players
      expect(Card.where(room_id: @room.id, player_id: user_id).length).to eq(user_cards_count - 3)
      expect(Card.where(room_id: @room.id, player_id: @player1.id).length).to eq(recipient_cards_count + 3)
    end
    it 'should flash a message that the card(s) were successfully given for a valid transaction' do
      @selected_players[@player1.id] = 1
      @cards_to_give.each { |card| @selected_cards[card.id] = 1 if @selected_cards.length < 3 }
      post :give_cards_transaction, cards_selected: @selected_cards, players_selected: @selected_players
      expect(flash[:notice]).to eq("Successfully gave 3 cards to #{@player1.name}")
      @selected_cards = {}
      @selected_cards[@cards_to_give.last.id] = 1
      post :give_cards_transaction, cards_selected: @selected_cards, players_selected: @selected_players
      expect(flash[:notice]).to eq("Successfully gave 1 card to #{@player1.name}")
    end
    it 'should create a flash warning if no recipients are selected' do
      @selected_cards[@cards_to_give.last.id] = 1
      post :give_cards_transaction, cards_selected: @selected_cards
      expect(flash[:warning]).to eq('Transaction Failed. You must select a recipient.')
    end
    it 'should create a flash warning if no cards are selected to transfer' do
      @selected_players[@player1.id] = 1
      post :give_cards_transaction, players_selected: @selected_players
      expect(flash[:warning]).to eq('Transaction Failed. You selected 0 cards to transfer.')
    end
    it 'should create a flash warning if more than one recipient is selected' do
      @selected_players[@player1.id] = 1
      @selected_players[@player2.id] = 1
      @cards_to_give.each { |card| @selected_cards[card.id] = 1 if @selected_cards.length < 3 }
      post :give_cards_transaction, cards_selected: @selected_cards, players_selected: @selected_players
      expect(flash[:warning]).to eq('Transaction Failed. You selected more than 1 recipient.')
    end
  end
  describe 'deleting all cards from a room' do
    it 'should redirect to the room page' do
      post :delete_decks_in_room
      expect(response).to redirect_to("/rooms/#{session[:room_token]}")
    end
    it 'should create a flash notice that all cards were deleted' do
      post :delete_decks_in_room
      expect(flash[:notice]).to eq("All cards deleted from room #{@room.id}.")
    end
  end
  # describe 'CRUD Operations' do
  #   it 'should call be able to search for cards' do
  #     cards_controller_double = class_double("cards_controller")
  #     fake_result = double('Card')
  #     expect(cards_controller_double).to receive(:show).with('3').
  #         and_return(fake_result)
  #
  #     post :show, {:id => '3'}
  #   end
  #   # Need to downgrade to Ruby 2.4.4 to run this test
  #   it 'should call be able to create new cards' do
  #     fake_new_card = {:room_id => '3', :value => '7', :suit => 'diamonds'}
  #     post :create, {:room_id => '3', :value => '7', :suit => 'diamonds'}
  #     expect(assigns(:card)).to eq(fake_new_card)
  #   end
  #   # Need to downgrade to Ruby 2.4.4 to run this test
  #   it 'should call be able to delete cards' do
  #
  #     cards_controller_double = class_double("cards_controller")
  #
  #     deck_num_to_delete = 1
  #
  #     allow(cards_controller_double).to receive(:delete_card_deck)
  #     post :delete_card_deck
  #     resulting_flash_message = flash[:notice].to_s
  #     expect_any_instance_of(resulting_flash_message.eql?("Deck number #{deck_num_to_delete} was destroyed.")).to be_truthy
  #   end
  #
  # end
    describe 'After game was ended. Other players should be redirect to room path upon any action' do
      before :each do
        session[:room_token] = Room.create_room!(name: 'name', public: 1).room_token
      end
      it 'user should get redirected when trying to delete decks' do
        # there is no information for Rooms besides auto-generated id
        token = session[:room_token]
        post :destroy, { id: token }
        post :delete_decks_in_room, { id: token }
        expect(response).to redirect_to('/rooms')
      end
      it 'user should get redirected when trying to draw cards' do
        # there is no information for Rooms besides auto-generated id
        token = session[:room_token]
        post :destroy, { id: token }
        post :draw_cards_from_dealer, { id: token }
        expect(response).to redirect_to('/rooms')
      end
      it 'user should get redirected when trying to give cards' do
        # there is no information for Rooms besides auto-generated id
        token = session[:room_token]
        post :destroy, { id: token }
        post :give_cards_transaction, { id: token }
        expect(response).to redirect_to('/rooms')
      end
    end
  end

=begin
  describe 'Transactions and Operations' do
    before :each do
      @account = Account.create!(username: 'valid2', email: 'valid@gmail.com', password: 'valid123!!')
      session[:session_token] = @account.session_token

    end

    it 'should be able to draw X cards from the dealer to multiple players' do
      # Create a room -- comes with dealer, sink, and 52 cards assigned to dealer
      post :create, room: { room_name: 'Test Name', public: 1 }
      id = assigns(:room_id)
      room = Room.find(id)

      @dealer = Player.where(name: 'dealer', room: room)
      @sink = Player.where(name: 'sink', room: room)


      # Drawing 3 cards from the dealer to the sink
      params = {"utf8"=>"✓", "authenticity_token"=>
          "PHUzdiVCW2cLjcktGhpgwBUy+5dmkFrWjZR0DacG/P/acB7nJaKXk3cg/zBSPxYRPl66QCywEGmk7HhUsh7b8Q==",
                "quantity"=>{"quantity"=>"3"}, "players_selected"=>{"2"=>"1"}, "class"=>"form",
                "controller"=>"cards", "action"=>"draw_cards_from_dealer"}

      # Create a test instance of the CardsController
      myCardsController = new CardsController

      # Call the function you're exercising in this test -- it will use the params you mocked up
      myCardsController.draw_cards_from_dealer

      puts("****************************** Dealer Length: " + @dealer.length)
      puts("****************************** Sink Length: " + @sink.length)

      expect(@dealer.length).to be(1)
      expect(@sink.length).to be(1)

      # Get the cards associated with the sink and the dealer after you've dealt
      dealer_cards = Card.where(room: room, player_id: @dealer.id)
      sink_cards = Card.where(room: room, player_id: @sink.id)

      puts("****************************** dealer_cards.length: " + dealer_cards.length)
      puts("****************************** sink_cards: " + sink_cards.length)

      # Test the lengths to ensure the correct number of cards were dealt
      expect(dealer_cards.length).to be(49)
      expect(sink_cards.length).to be(3)

    end

    it 'should be able to give cards from this player to another' do
    # Giving 2 cards from the sink to the dealer
    params = {"utf8"=>"✓", "authenticity_token"=>
        "8rZqR+XZQ28+qpwQTvC9e4ETZO4Z5PceaBtdUxrwk5oUs0fW5TmPm0IHqg0G1cuqqn8lOVPEvaFBY1EKD+i0lA==",
              "cards_selected"=>{"12"=>"1", "14"=>"1"}, "players_selected"=>{"1"=>"1"}, "class"=>"form",
              "controller"=>"cards", "action"=>"give_cards_transaction"}

    end

    it 'should be able to "flip" X number of cards on any entity in the room' do
    # Flipping over 2 of the dealer's cards
    params = {"utf8"=>"✓", "authenticity_token"=>
        "Tbyn0RPVTcf/wMPZwBhh6t1InDpA4hXFiqfS0cJ8jkiruYpAEzWBM4Nt9cSIPRc79iTd7QrCX3qj396I12SpRg==",
              "quantity_to_make_visible"=>{"quantity_to_make_visible"=>"2"},
              "player_id_to_make_cards_visible"=>{"1"=>"1"}, "class"=>"form", "controller"=>"cards",
              "action"=>"make_cards_visible"}


    end

  end
=end
