class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy
  before_save :create_room_token
  after_save :initialize_room

  def self.create_room!
    Room.create!
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

  def initialize_room
    dealer = Player.create!({ name: 'dealer', room: self })
    Player.create!({ name: 'sink', room: self })
    #dealer = Player.where(room: self, name: 'dealer')[0]
    Card.suits.each do |curr_suit|
      Card.values.each do |curr_value|
        curr_card = { room_id: id, value: curr_value, suit: curr_suit, player: dealer }
        Card.create!(curr_card)
      end
    end

  end
end