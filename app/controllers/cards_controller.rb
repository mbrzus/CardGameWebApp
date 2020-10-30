class CardsController < ApplicationController
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
end
