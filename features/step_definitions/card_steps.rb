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

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5.
# Note that you may need to add additional step definitions beyond these

# Add a declarative step here for populating the DB with add_name.

Given /the following cards have been dealt to players/ do |cards_table|
  cards_table.hashes.each do |card|
    Card.create!(card)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)

  # make sure all the boxes are unchecked
  ratings_list = %w[G PG PG-13 R NC-17]
  ratings_list.each do |rating|
    uncheck "ratings_#{rating}"
  end
  # check selected boxes
  new_rating_list = arg1.split(', ')
  new_rating_list.each do |rating|
    check "ratings_#{rating}"
  end
  click_button "ratings_submit"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  rating_list = arg1.split(', ')
  result=true
  all("tr").each do |tr|
    helper = false
    rating_list.each do |rating|
      helper = true if tr.has_content?(rating)
    end
    if !helper
      result = false
      break
    end
  end
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  # num_of_rows contains also the row specifying column names, thus we need to subtract 1
  num_of_rows = page.all('table#add_name tr').count - 1
  expect(num_of_rows).to eq Movie.count
end

When /^I click on "(.*)"$/ do |link|
  click_on link
end

Then /^I should see "(.*)" before "(.*)"$/ do |movie1, movie2|
  regexp = /#{movie1}.*#{movie2}/m  # similarly to chapter 7.8 in the book
  expect(page.body).to match(regexp)
end

Then /^I should be on the draw cards page$/ do |room_id|
  expect(current_path).to match('/cards/draw_cards')
end

When /^The dealer gives (.*?) cards from the draw cards page to player (.*?)$/ do |num_cards, player|
  player = Player.where(name: player)
  find(:css, "checkbox_#{player[0].id}").set(true)
  fill_in "quantity_dealer", :with => num_cards.to_s
end

Then /^I should be on the give cards page$/ do |room_id|
  expect(current_path).to match('/cards/give_cards')
end

When /^Player (.*?) gives cards to player (.*?)$/ do |giver, receiver|
  giver_cards = Card.where(name: giver)
  giver_cards.each { |x| find(:css, "checkbox_#{x.id}").set(true) }

  find(:css, "checkbox_#{receiver[0].id}").set(true)
end

Then /^Player (.*?) must have the cards that player (.*?) had$/ do |receiver, giver|
  expect(Card.where(player_id: giver.to_i)).to must_be_empty
end