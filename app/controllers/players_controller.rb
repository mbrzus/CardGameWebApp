class PlayersController < ApplicationController

  def player_params
    # function to extract a player_name string from params object
    params.require(:players)
  end

  def create
    player_params.each do |player|
      Player.create!(player)
    end
  end

  def new

  end

  def show

  end

end
