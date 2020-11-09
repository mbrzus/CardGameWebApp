class Room < ActiveRecord::Base
  before_save :create_room_token

  def self.create_room!
    Room.create!
  end

  def create_room_token
    self.room_token = SecureRandom.alphanumeric(5)
  end

end
