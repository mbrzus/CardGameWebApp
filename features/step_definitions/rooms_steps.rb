Given /the following rooms exist in the database:/ do |rooms_table|
  # Remove this statement when you finish implementing the test step
  rooms_table.hashes.each do |room|
    # this code was taken from homework 5 and modified for this project
    Room.create!(room)
  end
end

Given /^I am on the main page$/ do
  visit rooms_path
end

When /^I have pressed (.*?)$/ do |button_id|

  if button_id == "create_room_submit"
    @number_of_rooms = Room.count
  end

  find_by_id(button_id).click
end

Then /^I should be at the new room form$/ do
  # the current url should match the room path (rooms)
  expect(current_path).to match(/.*\/rooms\/new/)
end

Then /^A room should be created in the database$/ do
  # the current number of rooms in the database is greater than before
  expect(Room.count).to be > @number_of_rooms
end

When /I input "(.+)" into (.+)/ do |input_value, element_id|
  fill_in element_id, :with => input_value
end


Then /I should be directed to the create_player page/ do
  # the current url should match the room path (room/id)
  expect(current_path).to match(/\/players\/new/)
end