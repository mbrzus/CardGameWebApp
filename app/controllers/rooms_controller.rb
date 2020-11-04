class RoomsController < ApplicationController

  def show

  end

  def index

  end

  def new

  end

  def create
    # room has no info so just create an empty object
    new_room = Room.new
    new_room.save!
    @room_id = new_room.id
    redirect_to room_path(:id => @room_id)
  end

  def edit

  end

  def update

  end

  def destroy

  end

end