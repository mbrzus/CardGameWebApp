class CardsController < ApplicationController

  $NUMBER_OF_DECKS = 0
  SUITS = %w[diamonds clubs spades hearts]
  VALUES = %w[A 1 2 3 4 5 6 7 8 9 10 J Q K]

  # Define what params should follow the Card Model
  def card_params
    params.require(:card).permit(:id, :deck_number, :suit, :value, :owned_by)
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
    #redirect_to movies_path
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


end
