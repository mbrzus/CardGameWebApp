class Room < ActiveRecord::Base
  has_many :player
end