class Player < ActiveRecord::Base
  belongs_to :room

  # search for the player. If none found, create a new player
  def self.create_or_load(player)
    # look for an existing player with the given name in the given room
    existing_player = Player.where(name: player[:name]).where(room: player[:room]).first
    # if the player doesn't exist, create the player and return the details
    if !existing_player
      return Player.create!(player)
    else
      return existing_player
    end
  end

end
