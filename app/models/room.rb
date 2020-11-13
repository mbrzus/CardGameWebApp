class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy

  # create a new room and return its id to the caller
  def self.create_new_room(room_name, public_boolean)
    new_room = Room.new
    new_room.name = room_name
    new_room.public = public_boolean
    new_room.save!
    return new_room.id
  end
end