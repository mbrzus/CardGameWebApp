require 'spec_helper'
require 'rails_helper'

describe Card do

  # Add RSpec tests here
  describe "Get deck of cards", type: :view do
    it 'it should return a list of 52 items' do
      list_of_cards = Card.get_deck_of_cards
      expect(list_of_cards.length).to eq(52)
    end
    it 'The items returned should be hashes with value and suit params' do
      list_of_cards = Card.get_deck_of_cards
      expect(list_of_cards[0][:suit]).to_not be_nil
      expect(list_of_cards[0][:value]).to_not be_nil
    end
  end
end