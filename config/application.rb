require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

require 'elasticsearch/rails/tasks/import'
require 'elasticsearch/rails/instrumentation'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

if Rails.env.development?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
end

module Eventizer
  class Application < Rails::Application

    Gaston.configure do |gaston|
      gaston.env = Rails.env
      gaston.files = Dir[Rails.root.join("config/gaston/**/*.yml")]
    end

    config.api_only = true # load full Middleware stack

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(
      #{config.root}/app/controllers/concerns
      #{config.root}/app/models/concerns
      #{config.root}/lib
      #{config.root}/lib/eventizer
    )

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.initialize_on_precompile = false

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helpers false
      g.template_engine :slim
      g.test_framework :rspec, fixtures: true, view_specs: false, routing_specs: false
      g.integration_tool nil
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.middleware.use Rack::ContentLength
  end
end
