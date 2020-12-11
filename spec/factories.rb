# All files and code related to the factory bot follows this guide:
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    username { 'testname' }
    email { 'email@test.com' }
    password { 'password' }
  end

  factory :room do
    name { 'room name' }
    add_attribute(:public) { true }
  end

end
