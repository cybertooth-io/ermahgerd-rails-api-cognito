# frozen_string_literal: true

# The Ermahgerd namespace.
module Ermahgerd
  # The default configuration object for the Ermahgerd AWS Cognito project.
  class Configuration
    attr_accessor(
      # The number of seconds until the access token expires
      # At runtime use environment variable `ACCESS_TOKEN_EXPIRE_SECONDS`
      # Defaults to 3600 seconds (1 hour)
      :access_token_expire_seconds,
      # The number of leeway seconds to use in calculating whether a token is expired.
      # At runtime use environment variable `ACCESS_TOKEN_LEEWAY_SECONDS`
      # Defaults to 0 seconds.
      :access_token_leeway_seconds,
      # The URL that the user will need to follow to set their password.  Used in the welcome email.
      # At runtime use environment variable `CLIENT_ACTIVATE_URL`
      # Defaults to `http://localhost:4200/login`
      :client_activate_url,
      # The URL that the user can use to trigger the forgotten password process.  Used in the welcome email.
      # At runtime use environment variable `CLIENT_FORGOT_PASSWORD_URL`
      # Defaults to `http://localhost:4200/forgot-password`
      :client_forgot_password_url,
      # The URL that the user can follow to sign into the client.  Used in the welcome email.
      # At runtime use environment variable `CLIENT_SIGN_IN_URL`
      # Defaults to `http://localhost:4200/login`
      :client_sign_in_url,
      # Whether or not to record `SessionActivity` in the `BaseResourceController`
      # At runtime use environment variable `RECORD_SESSION_ACTIVITY`
      # Defaults to true
      :record_session_activity,
      # The id token's audience.  Found in Rails 5 credentials.  See the README.md for more information.
      :token_aud,
      # The id token's issuer.  Found in Rails 5 credentials.  See the README.md for more information.
      :token_iss
    )

    # Initialize the Ermahgerd configuration with sane/development defaults.
    # These will could be clobbered by the `config/initializers/ermahgerd.rb`
    def initialize
      self.access_token_expire_seconds = ENV.fetch('ACCESS_TOKEN_EXPIRE_SECONDS') { 3600 }

      self.access_token_leeway_seconds = ENV.fetch('ACCESS_TOKEN_LEEWAY_SECONDS') { 0 }

      self.client_activate_url = ENV.fetch('CLIENT_ACTIVATE_URL') { 'http://localhost:4200/login' }

      self.client_forgot_password_url =
        ENV.fetch('CLIENT_FORGOT_PASSWORD_URL') { 'http://localhost:4200/forgot-password' }

      self.client_sign_in_url = ENV.fetch('CLIENT_SIGN_IN_URL') { 'http://localhost:4200/login' }

      self.record_session_activity = ENV.fetch('RECORD_SESSION_ACTIVITY') { true }

      self.token_aud = Rails.application.credentials.dig(:token_aud)

      self.token_iss = Rails.application.credentials.dig(:token_iss)
    end
  end

  class << self
    attr_accessor :configuration
  end

  @configuration ||= Configuration.new

  def self.configure
    yield(@configuration)
  end
end
