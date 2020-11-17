require 'spec_helper'
require 'rails_helper'

describe Room do
  describe "Create New Room" do
    it 'it should create a new room object' do
      # call the function we are testing
      room_id = Room.create_room!(name: "Test Room Name", public: true).id
      # player should have been created
      created_room = Room.find(room_id)
      expect(created_room.public).to eq(true)
      expect(created_room.name).to eq("Test Room Name")
    end
  end
end