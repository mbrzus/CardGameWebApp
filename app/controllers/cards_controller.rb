class CardsController < ApplicationController

  before_filter :set_current_user
  before_filter :check_room_exists

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

  # This method can be used to delete any card that has a certain deck number
  def delete_decks_in_room

    # Resource used to craft this query
    # https://blog.bigbinary.com/2019/03/13/rails-6-adds-activerecord-relation-delete_by-and-activerecord-relation-destroy_by.html
    Card.where(room_id: session[:room_id]).destroy_all

    flash[:notice] = "All cards deleted from room #{session[:room_id].to_s}."
    redirect_to room_path(:id => session[:room_token])
  end

  # This method will be used strictly for drawing cards from the dealer and will have
  # an associated GUI where the user can say how many cards they want to draw and
  # which user the cards should go to. Can be themselves OR others in the game.
  # There could be a drop down box
  #
  # DRAW CARDS
  #  ----------------------------------------
  # | Input Quantity | Select Destination V |
  #  ----------------------------------------
  # |       5        |      Jacob          |
  # |                |      Daniel     X   |
  # |                |      Sink1          |
  # |                |      Shriram        |
  # |                |      Jack           |
  # |________________|_____________________|
  #
  def draw_cards_from_dealer
    invalid_input = false

    dealer = Player.find_by(room_id: session["room_id"].to_i, name: "dealer")

    # Read input quantity from view
    quantity_to_draw = params[:quantity][:quantity].to_i

    # Check for invalid input
    if quantity_to_draw.is_a?(Integer) == false || quantity_to_draw <= 0
      flash[:warning] = "ERROR: Invalid input. Must input a positive, numeric value to deal."
      invalid_input = true
    end


    if params[:players_selected].eql?(nil)
      flash[:warning] = "ERROR: Invalid input. Must choose atleast 1 player to deal to."
      invalid_input = true
    end

    if invalid_input == false

      # Read input player IDs array from view
      selected_players_ids = params[:players_selected].keys
      recipients = []

      # Fetch the Player models corresponding to the passed in IDs
      selected_players_ids.each do |curr_id|
        recipients << Player.where(room_id: session["room_id"].to_i, id: curr_id).first
      end

      # Get the dealer's cards
      dealers_cards = Card.where(room_id: session["room_id"].to_i, player_id: dealer.id)

      # Shuffle them before you distribute them to other players
      # Resource used: https://apidock.com/ruby/Array/shuffle%21
      dealers_cards_array = dealers_cards.to_a
      dealers_cards_array.shuffle!

      # Ensure the dealer has enough cards to deal the requested quantity
      if dealers_cards.length >= ( quantity_to_draw * recipients.length)

        (0..quantity_to_draw - 1).each { |curr_dealer_card|
          (0..recipients.length - 1).each { |curr_recipient|
            # Reassign the card from the dealer to the recipient, being sure to remove it from dealers_cards_array[]
            dealers_cards_array[curr_dealer_card].change_owner(recipients[curr_recipient].id)
            dealers_cards_array.delete(dealers_cards_array[curr_dealer_card])
          }
        }

        recipient_names_string = ""

        recipients.each do |curr_recipient|
          recipient_names_string.concat(curr_recipient.name, ", " )
        end

        flash[:notice] = "Successfully dealt #{quantity_to_draw.to_s} cards to #{recipient_names_string}"

      else
        flash[:warning] = "Dealer can not deal the requested number of cards"
      end

    end
    # Send the user back to their room view
    redirect_to room_path(:id => session[:room_token])

  end

  # This method will be used strictly for player-to-player and player-to-sink card transactions where the
  # calling user is GIVING cards to another user or discarding cards to a sink. An associated GUI will show
  # checkboxes next to all of the players cards and checkboxes next to all of the other players or sinks in
  # a game, allowing the user to select multiple cards and a single user or sink that they want to give the cards to.
  # The GUI could look something like this
  #
  #  GIVE CARDS TO
  #  ----------------------------------------
  # | Select Cards V | Select Destination V |
  #  ----------------------------------------
  # |      7H     X  |      Jacob          |
  # |      10D       |      Daniel         |
  # |      QC     X  |      Sink1      X   |
  # |      9S        |      Shriram        |
  # |                |      Jack           |
  # |________________|_____________________|
  #
  # Expected params:
  # :room_id - the id of the room that the transaction is occurring in
  # :giving_players_name - the name of the player who is giving the cards
  # :receiving_player_name - the name of the player who is receiving the cards
  # :ids_of_cards_to_give - an array of ids for cards that the giving player has chosen to give
  #
  def give_cards_transaction
    invalid_input = false

    # Read in the recipient and ensure input is as expected
    if params[:players_selected].eql?(nil)
      flash[:warning] = "Transaction Failed. You must select a recipient."
      invalid_input = true
    end
    # Read in the ids of the selected cards from the view. Ensure they selected at least 1 card
    if params[:cards_selected].eql?(nil)
      flash[:warning] = "Transaction Failed. You selected 0 cards to transfer."
      invalid_input = true
    end

    # Get the receiving player from information passed into the view
    receiving_player_id = params[:players_selected].keys
    receiving_player = nil
    # Ensure the user only selected a SINGLE recipient
    if receiving_player_id.length == 1
      receiving_player = Player.where(room_id: session["room_id"].to_i,
                                      id: receiving_player_id[0].to_i).first
    else
      flash[:warning] = "Transaction Failed. You selected more than 1 recipient."
      invalid_input = true
    end

    if invalid_input == false

      # Get the giving player from information stored in the session
      giving_player = Player.where(room_id: session["room_id"].to_i,
                                   name: session[session["room_id"].to_i]["name"]).first

      cards_to_give_ids = params[:cards_selected].keys
      cards_to_give = []

      # Get the Card models associated with the passed in IDs
      cards_to_give_ids.each do |curr_card_id|
        cards_to_give << Card.where(room_id: giving_player.room_id, player_id: giving_player.id,
                                    id: curr_card_id.to_i).first
      end

      (0..cards_to_give.length - 1).each{ |i|
        # Reassign the card from the giver to the recipient
        cards_to_give[i].change_owner(receiving_player.id)
      }

      # Output success message to user
      if cards_to_give.length == 1
        flash[:notice] = "Successfully gave #{cards_to_give.length} card to #{receiving_player.name.to_s}"
      else
        flash[:notice] = "Successfully gave #{cards_to_give.length} cards to #{receiving_player.name.to_s}"
      end

    end

    # Send the user back to their room view
    redirect_to room_path(:id => session[:room_token])
  end

  def draw_cards
    @players = Player.where(room_id: params[:room_id])
  end

  def give_cards
    room_id = params[:room_id].to_i
    giving_player = session[room_id.to_s]
    cards_to_give = Card.where(room_id: giving_player["room_id"], player_id: giving_player["id"])
    @cards_to_give_array = cards_to_give.to_a

    @players = Player.where(room_id: room_id)
  end
end
























