require 'spec_helper'
require 'rails_helper'

describe Card do
  describe "Create Card" do
    it 'Create New Card' do
      # call the function we are testing
      card_id = Card.create!(:room_id => 1, :value => 'A', :suit => 'spades', :player_id => 1,
                             :image_url => 'AS.png', :visible => false).id
      # player should have been created
      created_card = Card.find(card_id)
      expect(created_card.visible).to eq(false)
      expect(created_card.value).to eq("A")
      expect(created_card.suit).to eq("spades")
      expect(created_card.player_id).to eq(1)
      expect(created_card.room_id).to eq(1)
    end
  end
  describe "Change Owner" do
    it 'if the change_owner() function is called on a card, the owner should change' do
      card_id = Card.create!(:room_id => 1, :value => 'A', :suit => 'spades', :player_id => 1,
                             :image_url => 'AS.png', :visible => false).id

      created_card = Card.find(card_id)
      created_card.change_owner(2)
      expect(created_card.player_id).to eq(2)
    end
  end
  describe "Get deck of cards", type: :view do
    it 'it should return a list of 52 items' do
      list_of_cards = Card.get_deck_of_cards
      expect(list_of_cards.length).to eq(52)
    end
    it 'The items returned should be card objects' do
      list_of_cards = Card.get_deck_of_cards
      expect(list_of_cards[0].class).to be(Card)
    end
  end
  describe "Make Visible" do
    it 'if the make_visible() function is called by a card, the card should become visible to all' do
      card_id = Card.create!(:room_id => 1, :value => 'A', :suit => 'spades', :player_id => 1,
                             :image_url => 'AS.png', :visible => false).id

      created_card = Card.find(card_id)
      created_card.make_visible
      expect(created_card.visible).to eq(true)
    end
  end

end
