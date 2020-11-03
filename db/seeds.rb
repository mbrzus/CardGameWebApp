# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)





# define a few rooms to be inserted into the database
rooms =  [{}, {}, {}]

# add each room to the development database
rooms.each do |room|
  Room.create!(room)
end