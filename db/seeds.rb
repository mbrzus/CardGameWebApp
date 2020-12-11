# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# define a few rooms to be inserted into the database
rooms =  [{:id => 1, :name => "First Room", :public => true, :player_limit => 50 },
          {:id => 2, :name => "Room 2", :public => false, :player_limit => 20 },
          {:id => 3, :name => "The third Room", :public => true, :player_limit => 5 }]



# add each room to the development database
rooms.each do |room|
  room = Room.create!(room)
  room.initialize_room("A-D,A-C,A-S,A-H,2-D,2-C,2-S,2-H,3-D,3-C,3-S,3-H,4-D,4-C,4-S,4-H,5-D,5-C,5-S,5-H,6-D,6-C,6-S,6-H,7-D,7-C,7-S,7-H,8-D,8-C,8-S,8-H,9-D,9-C,9-S,9-H,10-D,10-C,10-S,10-H,J-D,J-C,J-S,J-H,Q-D,Q-C,Q-S,Q-H,K-D,K-C,K-S,K-H,")
end

# Create a dealer for every room you create, starting with ids 1,2,3
players = [
           {:id => 7, :name => "Steve", :room_id => 1},
           {:id => 8, :name => "Ted", :room_id => 1},
           {:id => 9, :name => "Ted", :room_id => 3},
           {:id => 10, :name => "Ned", :room_id => 3},
           {:id => 11, :name => "Fred", :room_id => 3},
           {:id => 14, :name => "Dealer", :room_id => 3},
           {:id => 15, :name => "Sink", :room_id => 3},
           {:id => 12, :name => "Ded", :room_id => 3},
           {:id => 13, :name => "Red", :room_id => 3},]

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


