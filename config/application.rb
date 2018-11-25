# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ErmahgerdRailsApiCognito
  # The rails application.  Note the name of the module this belongs too.  If you duplicate repos you will want to
  # adjust this module name.
  class Application < Rails::Application
    require 'ermahgerd'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.access_token_expire_seconds = ENV.fetch('ACCESS_TOKEN_EXPIRE_SECONDS') { 3600 }

    config.access_token_leeway_seconds = ENV.fetch('ACCESS_TOKEN_LEEWAY_SECONDS') { 0 }

    config.refresh_token_expire_days = ENV.fetch('REFRESH_TOKEN_EXPIRE_DAYS') { 365 }

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Whether or not to record `SessionActivity` in the `BaseResourceController`
    config.record_session_activity = ENV.fetch('RECORD_SESSION_ACTIVITY') { true }

    # The id token's audience
    config.token_aud = ENV.fetch('TOKEN_AUD') { 'ermahgerd' }

    # The id token's issuer
    config.token_iss = ENV.fetch('TOKEN_ISS') { 'https://cognito-idp.ca-central-1.amazonaws.com/us-east-1_example' }

    config.version = '0.0.1-rc.2'
  end
end
