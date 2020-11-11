class Room < ActiveRecord::Base
  before_save :create_room_token
  has_many :player

  def self.create_room
    initialize_room
    Room.create!
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

  def initialize_room
    Player.create!({ name: 'dealer', room: id} )
    Card.suits.each do |curr_suit|
      Card.values.each do |curr_value|
        curr_card = { room_id: id, value: curr_value, suit: curr_suit, owned_by: "dealer" }
        Card.create!(curr_card)
      end
    end

  end
end

