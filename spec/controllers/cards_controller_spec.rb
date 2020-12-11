require 'spec_helper'
require 'rails_helper'

describe CardsController do
  before :each do
    # Ensure the test database includes an initial room with two players other than the dealer and sink
    @room = Room.create_room!(name: 'test', player_limit: 5, public: 1)
    @room.initialize_room("A-D,A-C,A-S,A-H,2-D,2-C,2-S,2-H,3-D,3-C,3-S,3-H,4-D,4-C,4-S,4-H,5-D,5-C,5-S,5-H,
6-D,6-C,6-S,6-H,7-D,7-C,7-S,7-H,8-D,8-C,8-S,8-H,9-D,9-C,9-S,9-H,10-D,10-C,10-S,10-H,J-D,J-C,J-S,J-H,Q-D,Q-C,Q-S,Q-H,K-D,
K-C,K-S,K-H,")
    Player.create!({ name: 'current user', room: @room })
    @player1 = Player.create!({ name: 'player1', room: @room })
    @player2 = Player.create!({ name: 'player2', room: @room })
    @players = Player.where(room_id: @room_id)
    @dealer = Player.find_by(room_id: @room.id, name: 'dealer')
    # Initialize the session variables we've been working to ensure tests run like a player is logged in and has joined
    # a room.
    session[:session_token] = Account.create!(username: 'valid', email: 'valid@gmail.com',
                                              password: 'valid123!!').session_token
    session[:room_token] = @room.room_token
    session[:room_id] = @room.id
    session[@room.id] = Player.login({ name: 'current user', room: @room })
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
      dealers_cards = Card.where(room_id: @room.id, player_id: @dealer.id)
      dealers_cards_array = dealers_cards.to_a
      dealers_cards_array.shuffle!
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
    it 'should flash a warning when no players are selected' do
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
  describe 'After game was ended. Other players should be redirect to room path upon any action' do
    before :each do
      session[:room_token] = nil
    end
    it 'user should get redirected when trying to delete decks' do
      # there is no information for Rooms besides auto-generated id
      post :delete_decks_in_room, { id: session[:room_token] }
      expect(response).to redirect_to('/rooms')
    end
    it 'user should get redirected when trying to draw cards' do
      # there is no information for Rooms besides auto-generated id
      post :draw_cards_from_dealer, { id: session[:room_token] }
      expect(response).to redirect_to('/rooms')
    end
    it 'user should get redirected when trying to give cards' do
      # there is no information for Rooms besides auto-generated id
      post :give_cards_transaction, { id: session[:room_token] }
      expect(response).to redirect_to('/rooms')
    end
  end
  describe 'rendering the flip cards view' do
    before :each do
      post :flip_cards, { room_id: @room.id }
    end
    it 'should render the flip cards template' do
      expect(response).to render_template('flip_cards')
    end
    it 'should render a view that includes the name of each player (including dealer/sink) when dealing cards' do
      @players.each do |player|
        expect(response.body).to include(player.name)
      end
    end
  end
  describe 'make cards visible action' do
    context 'and has valid input' do
      before :each do
        @num_visible = Card.where(room_id: @room.id, player_id: @player1.id, visible: true).length
        post :draw_cards_from_dealer, quantity: { quantity: 5 }, players_selected: { "#{@player1.id}": 1 }
        post :make_cards_visible, { quantity_to_make_visible: { quantity_to_make_visible: 3 }, player_id_to_make_cards_visible: { "#{@player1.id}": 1 } }
      end
      it 'should allow users to flip the correct number of cards' do
        expect(Card.where(room_id: @room.id, player_id: @player1.id, visible: true).length).to eq(@num_visible + 3)
      end
      it 'should display a flash message saying the number of cards flipped and the opponents name' do
        expect(flash[:notice]).to eq("Successfully flipped 3 of #{@player1.name}'s cards.")
      end
    end
    context 'and has invalid input' do
      it 'should display a flash warning notifying the user they did not select a player/sink/source' do
        post :make_cards_visible, { quantity_to_make_visible: { quantity_to_make_visible: 3 } }
        expect(flash[:warning]).to eq('Card flip Failed. You must select player/sink/source to flip cards for.')
      end
      it 'should display a flash warning notifying the user of an invalid number of players' do
        post :make_cards_visible, { quantity_to_make_visible: { quantity_to_make_visible: 3 }, player_id_to_make_cards_visible: { } }
        expect(flash[:warning]).to eq('Card flip Failed. You selected an invalid number of players')
      end
      it 'should display a flash warning notifying the user of an invalid number of cards to flip' do
        post :make_cards_visible, { quantity_to_make_visible: { 'quantity_to_make_visible' => '' }, player_id_to_make_cards_visible: { "#{@player1.id}": 1 } }
        expect(flash[:warning]).to eq('Card Flip Failed. Invalid number of cards selected to flip.')
      end
      it 'should display a flash warning notifying the user of an invalid number of cards to flip' do
        post :make_cards_visible, { quantity_to_make_visible: { 'quantity_to_make_visible' => '' }, player_id_to_make_cards_visible: { "#{@player1.id}": 1 } }
        expect(flash[:warning]).to eq('Card Flip Failed. Invalid number of cards selected to flip.')
      end
      it 'should display a flash warning notifying the user of an invalid number of cards to flip for no input' do
        post :make_cards_visible, { player_id_to_make_cards_visible: { "#{@player1.id}": 1 } }
        expect(flash[:warning]).to eq('Card Flip Failed. Invalid number of cards selected to flip.')
      end
    end
  end
  describe 'rendering the toggle cards view' do
    before :each do
      post :toggle_my_cards, { room_id: @room.id }
    end
    it 'should render the flip cards template' do
      expect(response).to render_template('toggle_my_cards')
    end
    it 'should render a view that includes each card a player has' do
      Card.where(room_id: @room.id, player_id: session[@room.id].id).each do |card|
        expect(response.body).to include("#{card[:value]}#{card[:suit][0, 1].upcase}.png")
      end
    end
  end
  describe 'toggle cards visibility action' do
    context 'and has valid input' do
      before :each do
        post :draw_cards_from_dealer, quantity: { quantity: 10 }, players_selected: { "#{session[@room.id].id}": 1 }
        my_cards = Card.where(room_id: @room.id, player_id: session[@room.id].id)
        @selected_cards = {}
        4.times { |i| @selected_cards[my_cards[i].id] = 1 }
        @num_visible = Card.where(room_id: @room.id, player_id: session[@room.id].id, visible: true).length
        post :toggle_my_card_visibility, { cards_to_toggle: @selected_cards }
      end
      it 'should allow users to flip the correct number of cards' do
        expect(Card.where(room_id: @room.id, player_id: session[@room.id].id, visible: true).length).to eq(@num_visible + 4)
      end
      it 'should display a flash message saying the number of your cards flipped' do
        expect(flash[:notice]).to eq('Successfully flipped 4 of your cards.')
      end
    end
    context 'and has invalid input' do
      it 'should display a flash warning notifying the user they did not select any cards to toggle' do
        post :toggle_my_card_visibility, {}
        expect(flash[:warning]).to eq('Card Flip Failed. Invalid number of cards selected to flip.')
      end
    end
  end
  describe 'rendering the take cards choose player view' do
    before :each do
      post :take_cards_choose_player, { room_id: @room.id }
    end
    it 'should render the take cards choose players template' do
      expect(response).to render_template('take_cards_choose_player')
    end
    it 'should render a view that includes the name of each player (including dealer/sink) when dealing cards' do
      @players.each do |player|
        expect(response.body).to include(player.name)
      end
    end
  end
  describe 'rendering the take cards choose player view' do
    before :each do
      post :take_cards_choose_player, { room_id: @room.id }
    end
    it 'should render the take cards choose players template' do
      expect(response).to render_template('take_cards_choose_player')
    end
    it 'should render a view that includes the name of each player (including dealer/sink) when dealing cards' do
      @players.each do |player|
        expect(response.body).to include(player.name)
      end
    end
  end
  describe 'rendering the take cards choose cards view' do
    context 'and the dealer has visible cards' do
      it 'should allow users to take the correct number of cards' do
        post :make_cards_visible, { quantity_to_make_visible: { quantity_to_make_visible: 3 }, player_id_to_make_cards_visible: { "#{@dealer.id}": 1 } }
        expect(flash[:notice]).to eq("Successfully flipped 3 of #{@dealer.name}'s cards.")
        flash[:warning] = nil
        post :take_cards_choose_cards, player_to_take_from: { "#{@dealer.id}": 1 }
        expect(flash[:warning]).to eq(nil)
      end
    end
    context 'and has invalid input' do
      it 'should display a flash warning notifying the user they did not select a player to take cards from' do
        post :take_cards_choose_cards
        expect(flash[:warning]).to eq('Card Transaction Failed. No player selected to take cards from.')
      end
      it 'should display a flash warning notifying the user they can only select one player at a time' do
        post :take_cards_choose_cards, { player_to_take_from: { "#{@player1.id}": 1, "#{@player2.id}": 1 } }
        expect(flash[:warning]).to eq('Card Transaction Failed. You may only take cards from 1 player at a time.')
      end
      it 'should display a flash warning when a user tries to take cards from a dealer with no visible cards' do
        post :take_cards_choose_cards, player_to_take_from: { "#{@dealer.id}": 1 }
        expect(flash[:warning]).to eq('Dealer has no visible cards to take. To take invisible cards from dealer, use draw button.')
      end
      it 'should display a flash warning notifying the user the player their trying to take from has no cards' do
        post :take_cards_choose_cards, player_to_take_from: { "#{@player2.id}": 1 }
        expect(flash[:warning]).to eq('Card Transaction Failed. This player has no cards to take.')
      end
    end
  end
  describe 'take cards transaction' do
    context 'and has valid input' do
      before :each do
        post :draw_cards_from_dealer, quantity: { quantity: 10 }, players_selected: { "#{@player1.id}": 1 }
        post :draw_cards_from_dealer, quantity: { quantity: 4 }, players_selected: { "#{session[@room.id].id}": 1 }
        cards_to_take = Card.where(room_id: @room.id, player_id: @player1.id)
        @selected_cards = {}
        6.times { |i| @selected_cards[cards_to_take[i].id] = 1 }
        @current_num_cards = Card.where(room_id: @room.id, player_id: session[@room.id].id).length
        post :take_cards_transaction, cards_selected: @selected_cards
      end
      it 'should allow users to take the correct number of cards' do
        expect(Card.where(room_id: @room.id, player_id: session[@room.id].id).length).to eq(@current_num_cards + 6)
      end
      it 'should display a flash message saying the number of cards flipped and the other players name' do
        expect(flash[:notice]).to eq("Successfully took #{@selected_cards.length} cards from #{@player1.name}")
      end
    end
  end
end


