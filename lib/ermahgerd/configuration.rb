# frozen_string_literal: true

# WhyTF does Rubocop insist I put a comment here, but not on my other classes.  FML.
module Ermahgerd
  # The default configuration object for the Ermahgerd AWS Cognito project.
  class Configuration
    attr_reader(
      :access_token_expire_seconds,
      :access_token_leeway_seconds,
      :record_session_activity,
      :token_aud,
      :token_iss
    )

    attr_writer(
      :access_token_expire_seconds,
      :access_token_leeway_seconds,
      :record_session_activity,
      :token_aud,
      :token_iss
    )

    def initialize
      self.access_token_expire_seconds = ENV.fetch('ACCESS_TOKEN_EXPIRE_SECONDS') { 3600 }

      self.access_token_leeway_seconds = ENV.fetch('ACCESS_TOKEN_LEEWAY_SECONDS') { 0 }

      # Whether or not to record `SessionActivity` in the `BaseResourceController`
      self.record_session_activity = ENV.fetch('RECORD_SESSION_ACTIVITY') { true }

      # The id token's audience
      self.token_aud = Rails.application.credentials.dig(:token_aud)

      # The id token's issuer
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
