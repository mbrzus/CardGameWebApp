When /^I am on the login page$/ do
    visit('/login')
end

When /^I click on the signup button/ do
  click_on 'signup'
end

Then /^I should be on the sign_up page$/ do
  expect(current_path).to match(/.*\/accounts\/new/)
end

Then /^A new account with the username (.*?) should be created$/ do |username|
  username = Account.where(username: username)
  expect(username).to be_truthy
end

Given /The account with username "Shriram" exists/ do
  Account.create!({username: "Shriram", email: "shriram@gmail.com", password: "password" })
end

Then /^User "(.*?)" should be authenticated$/ do |username|
  expect(page).to have_content("Welcome "+ username+"!")
end

Then /^I should expect an invalid email error$/ do
  expect(page).to have_content("Username has already been taken, Email must be a valid address")
end