class AddRoomTokenToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :room_token, :string
  end
end
