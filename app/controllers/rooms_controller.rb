class RoomsController < ApplicationController

  def show
    @room_id = params[:id]
    @players = Player.all.select { |player| player[:room_id].to_s == @room_id.to_s }

    # get the player_id stored in this sessions id
    @player = session[@room_id.to_s]
    # if the player_id exists, join the game
    if !! @player
      # get all the game info
    else
      session[:room_to_join] = @room_id
      # the player has not logged in or doesnt exist, redirect to where they can create
      redirect_to new_player_path
    end
  end

  def index

  end

  def new

  end

  def create
    # room has no info so just create an empty object
    new_room = Room.new
    new_room.save!
    @room_id = new_room.id
    session[:room_to_join] = @room_id
    redirect_to room_path(:id => @room_id)
  end

  # the main page links to here. This controller just gets the room_id
  # from the submitted form and redirects the user to that path
  def join_room
    session[:room_to_join] = params.require(:room_id)["room_id"]
    redirect_to room_path(:id => session[:room_to_join])
  end

  def edit

  end

  def update

  end

  def destroy

  end

end