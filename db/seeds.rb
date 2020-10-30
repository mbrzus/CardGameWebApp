# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cards = [{:deck_number => '1', :value => 'A', :suit => 'spades', :owned_by => 'Jack'},
         {:deck_number => '1', :value => '7', :suit => 'hearts', :owned_by => 'Daniel'},
         {:deck_number => '1', :value => '9', :suit => 'clubs', :owned_by => 'none'},
         {:deck_number => '2', :value => 'Q', :suit => 'diamonds', :owned_by => 'Jacob'},
         {:deck_number => '2', :value => 'K', :suit => 'hearts', :owned_by => 'sink1'},
         {:deck_number => '2', :value => '6', :suit => 'spades', :owned_by => 'source3'}
          # add more cards to seed with a full deck of 52 if this works
        ]

cards.each do |curr_card|
  Card.create!(curr_card)
end
