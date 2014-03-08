source 'https://rubygems.org'

gem 'rails', '3.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'mongoid'
gem 'rails_admin'
gem 'thin'
gem 'jquery-rails'
gem "zeus"
gem "slim"
gem "slim-rails"
gem 'devise'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "therubyracer"
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem "twitter-bootstrap-rails"
end

group :test, :development do
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'guard-zeus'
end

group :development do
  gem 'pry-rails'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber', '~> 1.2.5', require: false # compat with yard-cucumber
  gem 'mongoid-rspec'
  gem 'pickle'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
end