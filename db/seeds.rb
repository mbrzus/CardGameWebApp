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

cards = [{:room_id => 1, :value => 'A', :suit => 'spades', :owned_by => 'dealer',
            :image_url => 'AS.png'},
         {:room_id => 1, :value => '7', :suit => 'hearts', :owned_by => 'dealer',
            :image_url => '7H.png'},
         {:room_id => 1, :value => '9', :suit => 'clubs', :owned_by => 'dealer',
            :image_url => '9C.png'},
         {:room_id => 2, :value => 'Q', :suit => 'diamonds', :owned_by => 'dealer',
            :image_url => 'QD.png'},
         {:room_id => 2, :value => 'K', :suit => 'hearts', :owned_by => 'dealer',
            :image_url => 'KH.png'},
         {:room_id => 2, :value => '6', :suit => 'spades', :owned_by => 'dealer',
            :image_url => '6S.png'}
          # add more cards to seed with a full deck of 52 if this works
        ]

cards.each do |curr_card|
  Card.create!(curr_card)
end

accounts = [
  { name: 'fake account', username: 'fake1', email: 'fake1@email.com', password: 'password' },
  { name: 'another fake account', username: 'fake2', email: 'fake2@email.com', password: 'password' }
]

accounts.each do |acc|
  Account.create!(acc)
end

