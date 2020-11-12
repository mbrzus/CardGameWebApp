class Room < ActiveRecord::Base
  has_many :player, dependent: :destroy
  has_many :card, dependent: :destroy
end