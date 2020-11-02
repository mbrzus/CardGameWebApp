# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cards = [{:room_id => 1, :value => 'A', :suit => 'spades'},
         {:room_id => 1, :value => '7', :suit => 'hearts'},
         {:room_id => 1, :value => '9', :suit => 'clubs'},
         {:room_id => 2, :value => 'Q', :suit => 'diamonds'},
         {:room_id => 2, :value => 'K', :suit => 'hearts'},
         {:room_id => 2, :value => '6', :suit => 'spades'}
          # add more cards to seed with a full deck of 52 if this works
        ]

cards.each do |curr_card|
  Card.create!(curr_card)
end
