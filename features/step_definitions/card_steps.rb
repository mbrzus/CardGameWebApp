# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie

Given /^I am on the card deck home page$/ do
  visit cards_path
end

  When /^I have added a deck in room number "(.*?)"$/ do |room_id|
    # this is a potential path to the cards database
    visit cards_path

    #TODO Fill 52 cards in the new room

  end

 Then /^I should see a list of cards with all suits and values in room id "(.*?)"$/ do |room_id|
   result=false
   all("tr").each do |tr|
     if tr.has_content?(room_id)
       result = true
       break
     end
   end
  expect(result).to be_truthy
 end

 When /^I have visited the Details about the card with suit "(.*?)" and value "(.*?)" in deck "(.*?)"$/ do |suit,value, deck|
   visit cards_path

   # TODO NEED TO CHANGE MORE ABOUT LINK
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^\"]*)"$/ do |text|
    expect(page).to have_content(text)
 end



# New step definitions to be completed for HW5.
# Note that you may need to add additional step definitions beyond these

# Add a declarative step here for populating the DB with add_name.

Given /the following cards have been dealt to players/ do |cards_table|
  cards_table.hashes.each do |card|
    Card.create!(card)
  end
end


When /^I click on "(.*)"$/ do |link|
  click_on link
end

Then /^I should see "(.*)" before "(.*)"$/ do |movie1, movie2|
  regexp = /#{movie1}.*#{movie2}/m  # similarly to chapter 7.8 in the book
  expect(page.body).to match(regexp)
end

Then /^I should be on the draw cards page$/ do |room_id|
  # Room_id query expected
  expect(current_path).to match(/.*\/cards\/draw_cards/)
end

When /^The dealer gives (.*?) cards from the draw cards page to player "(.*?)"$/ do |num_cards, player|
  player = Player.where({name: player})
  find(:id, "checkbox_#{player[0].id}").set(true)
  fill_in "quantity_dealer", :with => num_cards.to_s
  find_by_id('draw_cards_inside').click
end

Then /^I should be on the give cards page$/ do |room_id|
  # Room_id query expected
  expect(current_path).to match(/.*\/cards\/give_cards/)
end

When /^Player "(.*?)" gives cards to player "(.*?)"$/ do |giver_name, receiver_name|
  giver = Player.where(name: giver_name)
  giver_cards = Card.where(player_id: giver[0].id)
  giver_cards.each { |x| find(:cid, "checkbox_#{x.id}").set(true) }
  receiver = Player.where(name: receiver_name)
  find(:id, "checkbox_#{receiver[0].id}").set(true)
  find_by_id("give_cards_inside").click
end

Then /^Player "(.*?)" must have the cards that player "(.*?)" had$/ do |receiver, giver|
  expect(Card.where(player_id: Player.where(name: giver)).length).to be 0
end