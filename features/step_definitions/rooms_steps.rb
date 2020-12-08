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

When /^I input "(.+)" into (.+)/ do |input_value, element_id|
  fill_in element_id, :with => input_value
end


Then /^I should be directed to the create_player page$/ do
  # the current url should match the room path (room/id)
  expect(current_path).to match(/\/players\/new/)
end

Given /^I am on Room (.*?)$/ do |room|
  visit room_path(:id => room.to_s)
end

Then /^I should be on the main page with the notice "(.*?)"$/ do |notice|
  expect(current_path).to match(rooms_path)
  expect(page).to have_content(notice)
end

Then /^I still should be on room (.*?) with the notice "(.*?)"$/ do |room, notice|
  expect(current_path).to match(room_path(:id => room.to_i))
  expect(page).to have_content(notice)
end

Given /^The following rooms have been added to the database$/ do |rooms_table|
  rooms_table.hashes.each do |room|
    Room.create!(room)
  end
end

Given /^The following players have been added to the database$/ do |players_table|
  players_table.hashes.each do |player|
    Player.create!(player)
  end
end

Then /^I should be back at Room (.*?)$/ do |room_num|
  expect(current_path).to match(room_path(:id => room_num.to_i))
end