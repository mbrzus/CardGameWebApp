class RoomsController < ApplicationController

  before_filter :set_current_user
  before_filter :check_room_exists, only: [:reset, :destroy, :create_new_deck]

  def room_params
    params.require(:room).permit(:name, :public)
  end

  def show
    # If the user doesn't have room_token in their session set, they didn't click the button
    if session[:room_token].nil?
      flash[:notice] = 'Please join a room by entering a room code below'
      redirect_to rooms_path
    else
      # the player has not logged in or doesnt exist, redirect to where they can create
      @room_id = Room.find_by_room_token(session[:room_token]).id
      # Put the room_id in the session for use in other controllers
      session[:room_id] = @room_id
      dealer = Player.where(room_id: @room_id, name: 'dealer')[0]
      @deck = Card.where(player: dealer, room_id: @room_id)
      @player = session[@room_id]
      redirect_to new_player_path if session[@room_id].nil?
    end
  end

  def index
    # need to get the public rooms from the database to display to the user
    # public_rooms_information is a list of objects that contain - { room_name, room_id, [list of player names]}
    @public_rooms_information = Room.get_public_rooms_information
  end

  def new
    # get a list of cards for the user to select from
    @cards = Card.get_deck_of_cards
  end

  def create
    # room has no info so just create an empty object
    new_room = Room.create_room!(room_params)
    # initialize the new room with the cards the user selected for this room
    new_room.initialize_room(params["cards_to_use"])
    @room_id = new_room.id
    # Put the room_id in the session for use in other controllers
    session[:room_id] = @room_id
    session[:room_token] = new_room.room_token
    redirect_to room_path(id: session[:room_token])
  end

  # This method is used to create a new deck of 52 standard playing cards
  # In the future we can modify Card.suits/values to make a custom deck
  def create_new_deck
    dealer = Player.where(room_id: session[:room_id], name: "dealer").first
    Card.suits.each do |curr_suit|
      Card.values.each do |curr_value|
        # Dynamically create the :image_url based off of the known card value and first character from the suit naming
        # convention that was used for the images
        curr_card = {:room_id => session[:room_id], :value => curr_value, :suit => curr_suit,
                     :player_id => dealer.id, :image_url => "#{curr_value}#{curr_suit[0].upcase}.png"}
        Card.create!(curr_card)
      end
    end
    flash[:notice] = "New card deck created in room #{session[:room_id].to_s}"

    redirect_to room_path(:id => session[:room_token])

  end

  # the main page links to here. This controller just gets the room_id
  # from the submitted form and redirects the user to that path
  def join_room
    room_token = params.require(:room)['room_token']
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

  end

  def destroy
    room_token = params[:id]
    room = Room.find_by(room_token: room_token)
    room_id = room.id
    room.destroy
    flash[:notice] = 'Game ended successfully. Thank you for playing!'
    session.delete(:room_token)
    session.delete(room_id)
    redirect_to rooms_path
  end

  def reset
    room_token = params[:id]
    @room = Room.find_by(room_token: room_token)
    @room_cards = Card.where(room: @room)
    @dealer = Player.where(room: @room, name: 'dealer')[0]
    @dealer_id = @dealer.id
    @room_cards.each do |card|
      card.change_owner(@dealer_id)
    end
    flash[:notice] = 'Game reset successfully!'
    redirect_to room_path(:id => room_token)
  end

end
