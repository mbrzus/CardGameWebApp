class RoomsController < ApplicationController

  def show
    @room_id = params[:id]

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
    # need to get the public rooms from the database to display to the user
    # public_rooms_information is a list of objects that contain - { room_name, room_id, [list of player names]}
    @public_rooms_information = Room.get_public_rooms_information
  end

  def new

  end

  def create
    # pass in the room name and boolean describing if the room is public
    # function creates a new room and returns the room id
    @room_id = Room.create_new_room(params["room_name"]["room_name"], !!params["public"]["public"])

    Player.create!({:name => "dealer", :room => Room.find(@room_id)})
    Player.create!({:name => "sink", :room => Room.find(@room_id)})

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
    @room_id = params[:id]
    @room = Room.find(@room_id)
    @room.destroy
    flash[:notice] = "Game ended successfully. Thank you for playing!"
    redirect_to rooms_path
  end

  def reset
    @room_id = params[:id]
    @room_cards = Card.where(room_id: @room_id)
    @dealer = Player.where(room_id: @room_id, name: "dealer")[0]
    @dealer_id = @dealer.id
    @room_cards.each do |card|
      card.change_owner(@dealer_id)
    end
    flash[:notice] = "Game reset successfully!"
    redirect_to room_path(:id => @room_id)
  end

end