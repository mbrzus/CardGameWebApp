class Room < ActiveRecord::Base
  before_save :create_room_token

  def self.create_room!
    Room.create!
    #create_deck
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

  # def create_deck
  #   SUITS.each do |curr_suit|
  #     VALUES.each do |curr_value|
  #       curr_card = { room_id: id, value: curr_value, suit: curr_suit }
  #       Card.create!(curr_card)
  #     end
  #   end
  #
  # end
end
