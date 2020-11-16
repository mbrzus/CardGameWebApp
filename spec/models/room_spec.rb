require 'spec_helper'
require 'rails_helper'

describe Room do
  describe "Create New Room" do
    it 'it should create a new room object' do
      # call the function we are testing
      room_id = Room.create_new_room("Test Room Name", true)
      # player should have been created
      created_room = Room.find(room_id)
      expect(created_room.public).to eq(true)
      expect(created_room.name).to eq("Test Room Name")
    end
  end

  describe "Get Public Rooms information" do
    it 'it should return an array of hashes' do
      # call the function we are testing
      public_rooms = Room.get_public_rooms_information
      # player should have been created
      # assume that the test database has been seeded
      expect(public_rooms.length).to_not eq(0)
      public_room = public_rooms[0]
      expect(public_room).to have_key(:room_name)
      expect(public_room).to have_key(:room_id)
      expect(public_room).to have_key(:player_names_list)
    end
    it 'it should get the information for rooms in the database' do
      # call the function we are testing
      public_rooms = Room.get_public_rooms_information
      has = false
      public_rooms.each do |room|
        if room[:room_id] == 1
          has = true
        end
      end
      # player should have been created
      # assume that the test database has been seeded
      expect(has).to eq(true)
    end
  end
end