source 'http://rubygems.org'

ruby '2.6.6'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use the dotenv gem to load the api keys and secrets as environment variables
gem 'dotenv-rails'
# Use Haml as the templating library
gem 'haml'
gem 'json', '=1.8.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Use the omniauth gem and twitter gem
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'rails', '4.2.10'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Timezone data for windows users
#gem "tzinfo-data"

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Not needed for our final project
#gem 'themoviedb'

group :development do
   # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'capybara'
  # Use factory bot to instantiate instances of the classes we're testing.
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'rspec', '~>3.5'
  gem 'rspec-rails'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.3.6'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'cucumber-rails'#, :require=>false
  gem 'database_cleaner'
  gem 'rspec-expectations'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg', '~> 0.21.0' # for Heroku deployment
  gem 'rails_12factor'
end

