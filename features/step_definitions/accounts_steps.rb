When /^I am on the login page$/ do
    visit('/login')
end

Then /^I should be on the sign_up page$/ do
  expect(current_path).to match(/.*\/accounts\/new/)
end

Then /^A new account with the username (.*?) should be created$/ do |username|
  username = Account.where(username: username)
  expect(username).to be_truthy
end

Then /^User (.*?) should be authenticated$/ do |username|
  expect(page).to have_content("Welcome "+ username+"!")
end

Then /^I should expect an invalid email error$/ do
  expect(page).to have_content("Username has already been taken, Email must be a valid address")
end