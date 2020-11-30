require 'spec_helper'
require 'rails_helper'

describe CardsController do
  before :each do
    session[:session_token] = Account.create!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!').session_token
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

  end

  describe 'Transactions and Operations' do
    before :each do
      @account = Account.create!(username: 'valid', email: 'valid@gmail.com', password: 'valid123!!')
      session[:session_token] = @account.session_token

      # Create a room -- comes with dealer, sink, and 52 cards assigned to dealer
      post :create, room: { room_name: 'Test Name', public: 1 }
      id = assigns(:room_id)
      room = Room.find(id)

      # TODO: JACOB RESUME HERE
      # TODO: Assign params[] to equal REAL params values you copy and paste from a ByeBug run here

    end

    it 'should be able to draw X cards from the dealer to multiple players' do
      # TODO: Test draw_cards_from_dealer() by just manually calling it since you already faked params

    end

    it 'should be able to give cards from this player to another' do
    # TODO: Test give_cards_transaction()
    end

    it 'should be able to "flip" X number of cards on any entity in the room' do
    # TODO: Test make_cards_visible()
    end
  end



end