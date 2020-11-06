require 'spec_helper'
require 'rails_helper'

describe PlayersController
describe 'CRUD Operations' do
  it 'search for players' do
    players_controller_double = class_double("players_controller")
    fake_result = double('Player')
    expect(players_controller_double).to receive(:show).with('1').
        and_return(fake_result)
    post :show, {:id => '1'}
  end

  # Need to downgrade to Ruby 2.4.4 to run this test
  it 'create new player' do
    
  end

  # Need to downgrade to Ruby 2.4.4 to run this test
  it 'delete player' do

  end

end
