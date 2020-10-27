# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
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

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    Movie.create!(movie)
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
