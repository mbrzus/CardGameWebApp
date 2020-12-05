require 'spec_helper'
require 'rails_helper'

describe Player do
  describe "login", type: :view do
    it 'if the player does exist, they should be found and returned' do
      # create some dummy test values that our function will search for
      Room.create!({:id => 100})
      arguments = { :name => "Tim", :room => Room.find(100) }
      created_player = Player.create!(arguments)
      # call the function we are testing
      returned_player = Player.login(arguments)
      # check that both the player returned by the function and the player
      # found in the database within the function are the same as the one we defined
      expect(returned_player[:id]).to eq(created_player[:id])
    end
    it 'if the player doesnt exist, nil should be returned' do
      # create some dummy test values that our function will search for
      Room.create!({:id => 100})
      arguments = { :id => 107, :name => "Tim", :room => Room.find(100) }
      # call the function we are testing
      returned_player = Player.login(arguments)
      # player should have been created
      expect(returned_player).to be_nil
    end
  end
end