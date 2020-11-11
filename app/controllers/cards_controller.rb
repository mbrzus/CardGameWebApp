class CardsController < ApplicationController
  SUITS = %w[diamonds clubs spades hearts]
  VALUES = %w[A 2 3 4 5 6 7 8 9 10 J Q K]

  # Define what params should follow the Card Model
  def card_params
    params.require(:card).permit(:room_id, :suit, :value, :image_url, :player_id)
  end

  def show
    id = params[:id] # retrieve card ID from URI route
    @card = Card.find(id) # look up card by unique ID
  end

  def index
    @cards = Card.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @card = Card.create!(card_params)
    flash[:notice] = "#{@card.value} of #{@card.suit} was successfully created."

    # Put an appropriate redirect path here
    #redirect_to movies_path
  end

  def edit
    debugger
    @card = Card.find params[:id]
  end

  def update
    @card = Card.find params[:id]
    @card.update_attributes!(card_params)
    flash[:notice] = "#{@card.value} of #{@card.suit} was successfully updated."
    # Put an appropriate redirect path here
    redirect_to card_path(@card)

  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    flash[:notice] = "Room #{@card.room_id}'s #{@card.value} of #{@card.suit} was deleted."
    redirect_to cards_path
  end

  # This method can be used to create a new deck of 52 standard playing cards
  # For now, it just defaults to creating a new room and assigning all cards to the new room
  # We can change this after the first iteration
  def create_new_deck

    SUITS.each do |curr_suit|
      VALUES.each do |curr_value|
        # Dynamically create the :image_url based off of the known card value and first character from the suit naming
        # convention that was used for the images

        #TODO: Remove the hardcoding of dealer = player_id 1000 and new cards are all created in room 1000

        curr_card = {:room_id => 1000, :value => curr_value, :suit => curr_suit,
                     :player_id => "1000", :image_url => "#{curr_value}#{curr_suit[0].upcase}.png"}
        Card.create!(curr_card)
      end
    end
    flash[:notice] = "New card deck created in room 1000"

    redirect_to cards_path

  end

  # This method can be used to delete any card that has a certain deck number
  def delete_decks_in_room
    # Hard coding this now but once someone creates the views they can integrate with this function
    room_num_to_delete = 1

    # Resource used to craft this query
    # https://blog.bigbinary.com/2019/03/13/rails-6-adds-activerecord-relation-delete_by-and-activerecord-relation-destroy_by.html
    Card.where(room_id: room_num_to_delete.to_s).destroy_all

    flash[:notice] = "All decks deleted from room #{room_num_to_delete}."
    redirect_to cards_path
    end

end
