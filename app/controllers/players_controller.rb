class PlayersController < ApplicationController

  before_filter :set_current_user

  def player_params
    # function to extract a player_name string from params object
    params.require(:player_name)
  end

  def create
    # get the id of the room the user is creating a player for
    @room_id = session[:room_to_join].to_i
    player_hash = { :name => player_params["name"],
                    :room => Room.find(@room_id)
    }
    # create the player and store their information
    session[@room_id] = Player.create_or_load(player_hash)
    # go the rooms view
    redirect_to room_path(@room_id)
  end

  def new

  end

  def show

  end

  def index

  end
end
