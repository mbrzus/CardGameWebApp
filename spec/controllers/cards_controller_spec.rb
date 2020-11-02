require 'spec_helper'
require 'rails_helper'

describe CardsController do
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
      fake_new_card = {:deck_number => '3', :value => '7', :suit => 'diamonds', :owned_by => 'Jacob'}
      post :create, {:deck_number => '3', :value => '7', :suit => 'diamonds', :owned_by => 'Jacob'}
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
end