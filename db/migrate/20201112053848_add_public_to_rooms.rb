class AddPublicToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :public, :boolean
  end
end
