require 'spec_helper'
require 'rails_helper'

describe CardsController do
  describe 'CRUD Operations' do
    it 'should call be able to search for cards' do
      fake_result = double('Card')
      expect(Card).to receive(:show).with('3').
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
      allow(CardsController).to receive(:destory)
      post :destory, {:id => 3}
      resulting_flash_message = flash[:notice].to_s
      expect(resulting_flash_message.eql?("#{@card.value} of #{@card.suit} was deleted.")).to be_truthy
    end

  end
end