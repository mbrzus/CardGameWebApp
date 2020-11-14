class RoomsController < ApplicationController

  def show
    # If the user doesn't have room_token in their session set, they need to create a player first
    if session[:room_token].nil?
      redirect_to new_player_path
    else
      # the player has not logged in or doesnt exist, redirect to where they can create
      @room_id = Room.find_by_room_token(session[:room_token]).id
      dealer = Player.where(room_id: @room_id, name: 'dealer')[0]
      @deck = Card.where(player: dealer, room_id: @room_id)
      @player = session[@room_id]
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
    room_token = params.require(:room)["room_token"]
    if Room.find_by_room_token(room_token).nil?
      flash[:notice] = "No room exists with code: #{room_token}!"
      redirect_to rooms_path
    else
      session[:room_token] = room_token
      redirect_to room_path(id: session[:room_token])
    end
  end

  def edit

  end

  def update
    room = Room.find_by_room_token(session[:room_token])
    dealer = Player.where(room: room)
    @deck = Card.where(player: dealer, room: room)
    card = @deck.pop
    card.update_attributes!(owned_by: session[room.id])
  end

  def destroy
    room_token = params[:id]
    @room = Room.find_by(room_token: room_token)
    @room.destroy
    flash[:notice] = "Game ended successfully. Thank you for playing!"
    redirect_to rooms_path
  end

  def reset
    room_token = params[:id]
    @room = Room.find_by(room_token: room_token)
    @room_cards = Card.where(room: @room)
    @dealer = Player.where(room: @room, name: "dealer")[0]
    @dealer_id = @dealer.id
    @room_cards.each do |card|
      card.change_owner(@dealer_id)
    end
    flash[:notice] = "Game reset successfully!"
    redirect_to room_path(:id => room_token)
  end

end