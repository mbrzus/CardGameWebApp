Given /^I am on the main page$/ do
  visit rooms_path
end

When /I have pressed the (create-new-room-button)/ do |button_id|
  # store the current number of rooms in the database
  @number_of_rooms = Room.count
  click_button button_id
end

Then /a room should be created in the database/ do
  # the current number of rooms in the database is greater than before
  expect(Room.count).to be > @number_of_rooms
end

Then /Automatically enter the create room/ do
  # the current url should match the room path (room/id)
  expect(current_path).to match(/.*\/room\/[0-9]+]/)
end