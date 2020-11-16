class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy

  # create a new room and return its id to the caller
  def self.create_new_room(room_name, public_boolean)
    new_room = Room.new
    new_room.name = room_name
    new_room.public = public_boolean
    new_room.save!
    return new_room.id
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
      public_rooms_information << { :room_name => room.name, :room_id => room.id, :player_names_list => player_names_list }
    end

    # return the public rooms information to the user
    return public_rooms_information
  end
end