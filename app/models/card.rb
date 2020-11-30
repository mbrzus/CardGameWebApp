class Card < ActiveRecord::Base
  belongs_to :room
  belongs_to :player
  @visible
  @value
  @suit
  @image_url

  def self.suits
    %w[diamonds clubs spades hearts]
  end

  def self.values
    %w[A 2 3 4 5 6 7 8 9 10 J Q K]
  end

  # Helper function that will is called by methods in CardController that are used for card transactions
  def change_owner(new_owner_id)
    self.player_id = new_owner_id
    # Save the changes to the card to the database without validation
    # Resource: https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html#method-i-save
    self.save!
  end

  # returns a list of all the cards in the deck
  def self.get_deck_of_cards
    list_of_cards = []

    Card.values.each do |curr_value|
        Card.suits.each do |curr_suit|
        curr_card = { value: curr_value, suit: curr_suit, visible: true }
        # dont save the card to the database,
        list_of_cards << Card.create(curr_card)
      end
    end

    return list_of_cards
  end
end
