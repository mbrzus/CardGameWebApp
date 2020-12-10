class AddPlayerLimitToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :player_limit, :int
  end
end
