# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# define a few rooms to be inserted into the database
rooms =  [{:id => 1}, {:id => 2}, {:id => 3}]

# add each room to the development database
rooms.each do |room|
  Room.create!(room)
end

cards = [{:room_id => 1, :value => 'A', :suit => 'spades',
            :image_url => '2D.png'},
         {:room_id => 1, :value => '7', :suit => 'hearts',
            :image_url => '2D.png'},
         {:room_id => 1, :value => '9', :suit => 'clubs',
            :image_url => '2D.png'},
         {:room_id => 2, :value => 'Q', :suit => 'diamonds',
            :image_url => '2D.png'},
         {:room_id => 2, :value => 'K', :suit => 'hearts',
            :image_url => '2D.png'},
         {:room_id => 2, :value => '6', :suit => 'spades',
            :image_url => '2D.png'}
          # add more cards to seed with a full deck of 52 if this works
        ]

cards.each do |curr_card|
  Card.create!(curr_card)
end

