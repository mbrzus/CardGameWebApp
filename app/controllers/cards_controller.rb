class CardsController < ApplicationController

  $NUMBER_OF_DECKS = 0
  SUITS = %w[diamonds clubs spades hearts]
  VALUES = %w[A 1 2 3 4 5 6 7 8 9 10 J Q K]

  # Define what params should follow the Card Model
  def card_params
    params.require(:card).permit(:deck_number, :suit, :value, :owned_by)
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
    flash[:notice] = "#{@card.value} of #{@card.suit} was deleted."

    # Put an appropriate redirect path here
    #redirect_to movies_path
  end

  # This method can be used to create a new deck of 52 standard playing cards
  def create_new_deck
    # Resource used to learn this command
    # https://stackoverflow.com/questions/4974049/ruby-on-rails-getting-the-max-value-from-a-db-column/4974069
    curr_number_of_decks = Card.maximum("deck_number")
    new_number_of_decks = curr_number_of_decks.to_i + 1

    SUITS.each do |curr_suit|
      VALUES.each do |curr_value|
        curr_card = {:deck_number => new_number_of_decks, :value => curr_value, :suit => curr_suit, :owned_by => 'none'}
        Card.create!(curr_card)
      end
    end
    flash[:notice] = "New card deck number #{new_number_of_decks} was created."

    redirect_to cards_path

  end

  # This method can be used to delete any card that has a certain deck number
  def delete_card_deck
    # Hard coding this now but once someone creates the views they can integrate with this function
    deck_num_to_delete = 1

    # Resource used to craft this query
    # https://blog.bigbinary.com/2019/03/13/rails-6-adds-activerecord-relation-delete_by-and-activerecord-relation-destroy_by.html
    Card.where(deck_number: deck_num_to_delete.to_s).destroy_all

    flash[:notice] = "Deck number #{deck_num_to_delete} was destroyed."
    redirect_to cards_path
    end

end
