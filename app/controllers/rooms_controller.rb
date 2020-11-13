class RoomsController < ApplicationController

  def show
    # get the player_id stored in this sessions id
    @room_id = Room.find_by_room_token(session[:room_token]).id
    @deck = Card.where(owned_by: 'dealer', room_id: @room_id)
    @player = session[@room_id]
    # if the player_id exists, join the game
    if !! @player
      # get all the game info
    else
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
    new_room = Room.create_room!
    @room_id = new_room.id
    session[:room_token] = new_room.room_token
    puts session[:room_token]
    redirect_to room_path(id: session[:room_token])
  end

  # the main page links to here. This controller just gets the room_id
  # from the submitted form and redirects the user to that path
  def join_room
    session[:room_token] = params.require(:room)["room_token"]
    redirect_to room_path(id: session[:room_token])
  end

  def edit

  end

  def update
    @room_id = Room.find_by_room_token(session[:room_token]).id
    @deck = Card.where(owned_by: 'dealer', room_id: @room_id)
    card = @deck.pop
    card.update_attributes!(owned_by: session[@room_id])
  end

  def destroy

  end

end