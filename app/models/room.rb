class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy
  before_save :create_room_token
  # create a new room and return its id to the caller

  def self.create_room!(room_params)
    Room.create!(room_params)
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

  # When a room is created, it comes with a dealer with 52 cards assigned to him and a sink
  # cards to use is in the format value-suit,value-suit,value-suit,...
  # it contains the cards the user has selected to use for this room
  def initialize_room(cards_to_use)
    dealer = Player.create!({ name: 'dealer', room: self })

    # This is essentially the RoomController#create_new_deck() method without a redirect at the end
    Player.create!({ name: 'sink', room: self })

    # first, split the cards_to_use by the comma separator
    list_of_cards_to_use = cards_to_use.split(",")

    list_of_cards_to_use.each do |card_value_and_suit|
      # card_value_and_suit in the form value-suit -> split it into the components
      components = card_value_and_suit.split("-")

      curr_card = { room_id: id, value: components[0], suit: components[1], player: dealer, visible: false }
      Card.create!(curr_card)
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
