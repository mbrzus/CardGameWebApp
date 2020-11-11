class Card < ActiveRecord::Base
  belongs_to :room
  @value
  @suit
  @image_url
  belongs_to :player
end
