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
end