When /^I am on the (.*?) page$/ do |page|
    visit('/login')
end

Then /^I should be on the sign_up page$/ do
  expect(current_path).to match('/accounts/new')
end

Then /^A new account with the username (.*?) should be created$/ do |username|
  username = Account.where(username: username)
  expect(username).to be_truthy
end

Then /^User (.*?) should be authenticated$/ do |username|
  expect(page).to have_content("Welcome "+ username+"!")
end