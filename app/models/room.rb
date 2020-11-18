class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy
  before_save :create_room_token
  after_save :initialize_room
  # create a new room and return its id to the caller

  def self.create_room!(room_params)
    Room.create!(room_params)
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

  def initialize_room
    dealer = Player.create!({ name: 'dealer', room: self })
    Player.create!({ name: 'sink', room: self })
    Card.suits.each do |curr_suit|
      Card.values.each do |curr_value|
        curr_card = { room_id: id, value: curr_value, suit: curr_suit, player: dealer, visible: false }
        Card.create!(curr_card)
      end
    end
  end

  # gets information about the public rooms and returns them to the caller
  def self.get_public_rooms_information
    # will be a list of hashes that contain information about public rooms
    # The information needed is room name, room id, and a list of player names within that room
    public_rooms_information = []
    # get the public rooms out of the database
    public_rooms = Room.where(:public => true)
    # go through the public rooms and make the hash object
    public_rooms.each do |room|
      player_names_list = []
      # get all the players in the room and add their name to the list
      Player.where(:room => room).each do |player|
        if player.name != "dealer" and player.name != "sink"
          player_names_list << player.name
        end
      end
      # now that we have all the information, create the hash and add it in
      public_rooms_information << { :room_name => room.name,
                                    :room_token => room.room_token,
                                    :player_names_list => player_names_list }
    end

    # return the public rooms information to the user
    return public_rooms_information
  end
end
