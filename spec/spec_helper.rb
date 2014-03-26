# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
  config.include FactoryGirl::Syntax::Methods

  config.before :each do
    MongoEvent.__elasticsearch__.client.indices.delete index: MongoEvent.index_name rescue nil
    MongoEvent.__elasticsearch__.create_index! force: true rescue nil
    Mongoid.purge!
  end

  config.before(:all) { DeferredGarbageCollection.start }
  config.after(:all) { DeferredGarbageCollection.reconsider }
end
