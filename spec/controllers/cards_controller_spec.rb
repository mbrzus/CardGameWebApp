require 'spec_helper'
require 'rails_helper'

describe CardsController do
  before :each do
<<<<<<< HEAD
    session[:session_token] = Account.create!(username: 'testuser', email: 'testuser@gmail.com', password: 'valid123!!').session_token
=======
    session[:session_token] = Account.create!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!').session_token
>>>>>>> main
  end
  describe 'CRUD Operations' do
    it 'should call be able to search for cards' do
      cards_controller_double = class_double("cards_controller")
      fake_result = double('Card')
      expect(cards_controller_double).to receive(:show).with('3').
          and_return(fake_result)

      post :show, {:id => '3'}
    end
    # Need to downgrade to Ruby 2.4.4 to run this test
    it 'should call be able to create new cards' do
      fake_new_card = {:room_id => '3', :value => '7', :suit => 'diamonds'}
      post :create, {:room_id => '3', :value => '7', :suit => 'diamonds'}
      expect(assigns(:card)).to eq(fake_new_card)
    end
    # Need to downgrade to Ruby 2.4.4 to run this test
    it 'should call be able to delete cards' do

      cards_controller_double = class_double("cards_controller")

      deck_num_to_delete = 1

      allow(cards_controller_double).to receive(:delete_card_deck)
      post :delete_card_deck
      resulting_flash_message = flash[:notice].to_s
      expect_any_instance_of(resulting_flash_message.eql?("Deck number #{deck_num_to_delete} was destroyed.")).to be_truthy
    end

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


end