class PlayersController < ApplicationController

  before_filter :set_current_user

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

    # attempt to login as the specified player
    player = Player.login(player_hash)

    # if the login failed (the player doesn't exist)
    if player == nil
      # create the player if there is space for them
      # subtract 2 from the length for the dealer and sink
      if room.player_limit > room.player.length - 2
        # create the player and store their information
        session[@room_id] = Player.create!(player_hash)
      else
        # redirect back to the main page with an error message
        flash[:warning] = "There is no space in the room"
        redirect_to rooms_path()
        return
      end
    end

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
