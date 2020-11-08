class Card < ActiveRecord::Base
  @room_id
  @value
  @suit
  @owned_by
  # This field will be used in program memory to determine if the image
  # of the back or front of the card will be shown to the player. It is
  # not stored in the persistence layer because visibility of cards depends
  # on which player you are (you can see your own hand but others can't etc).
  @is_visible
  @image_url
end
