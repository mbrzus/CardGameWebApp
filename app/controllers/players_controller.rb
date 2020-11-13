class PlayersController < ApplicationController

  def player_params
    # function to extract a player_name string from params object
    params.require(:player_name)
  end

  def create
    # get the id of the room the user is creating a player for
    room = Room.find_by_room_token(session[:room_token])
    @room_id = room.id
    player_hash = { name: player_params['name'],
                    room: room }
    # create the player and store their information
    session[@room_id] = Player.create_or_load(player_hash)
    # go the rooms view
    redirect_to room_path(id: session[:room_token])
  end

  def new

  end

  def show

  end

  def index

  end
end
