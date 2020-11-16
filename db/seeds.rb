# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# define a few rooms to be inserted into the database
rooms =  [{:id => 1, :name => "First Room", :public => true},
          {:id => 2, :name => "Room 2", :public => false},
          {:id => 3, :name => "The third Room", :public => true}]

# add each room to the development database
rooms.each do |room|
  Room.create!(room)
end

# Create a dealer for every room you create, starting with ids 1,2,3
players = [{:id => 1, :name => "dealer", :room_id => 1},
           {:id => 3, :name => "dealer", :room_id => 2},
           {:id => 5, :name => "dealer", :room_id => 3},
           {:id => 2, :name => "sink", :room_id => 1},
           {:id => 4, :name => "sink", :room_id => 2},
           {:id => 6, :name => "sink", :room_id => 3},
           {:id => 7, :name => "Steve", :room_id => 1},
           {:id => 8, :name => "Ted", :room_id => 1}]

players.each do |curr_player|
  Player.create!(curr_player)
end

cards = [{:room_id => 1, :value => 'A', :suit => 'spades', :player_id => 1,
            :image_url => 'AS.png', :visible => false},
         {:room_id => 1, :value => '7', :suit => 'hearts', :player_id => 1,
            :image_url => '7H.png', :visible => false},
         {:room_id => 1, :value => '9', :suit => 'clubs', :player_id => 1,
            :image_url => '9C.png'},
         {:room_id => 1, :value => 'Q', :suit => 'diamonds', :player_id => 1,
            :image_url => 'QD.png'},
         {:room_id => 1, :value => 'K', :suit => 'hearts', :player_id => 1,
            :image_url => 'KH.png'},
         {:room_id => 1, :value => '6', :suit => 'spades', :player_id => 1,
            :image_url => '6S.png'},
         {:room_id => 1, :value => '7', :suit => 'hearts', :player_id => 7,
          :image_url => 'KH.png'},
         {:room_id => 1, :value => '9', :suit => 'spades', :player_id => 7,
          :image_url => '6S.png'}
          # add more cards to seed with a full deck of 52 if this works
        ]

cards.each do |curr_card|
  Card.create!(curr_card)
end

