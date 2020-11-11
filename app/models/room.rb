class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
end