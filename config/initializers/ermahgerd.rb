# frozen_string_literal: true

# Refer to `lib/ermahgerd/configuration.rb` `initialize` method to view the configuration defaults.
Ermahgerd.configure do |config|
  if Rails.env.test?
    # Admin Create Cognito User - URLS sent in welcome emails
    # ------------------------------------------------------------------------------------------------------------------

    config.client_activate_url = 'http://example.com/login'
    config.client_forgot_password_url = 'http://example.com/forgot-password'
    config.client_sign_in_url = 'http://example.com/login'

    # Cognito Token Verification Configuration
    # ------------------------------------------------------------------------------------------------------------------

    # The id token's audience
    config.token_aud = 'ermahgerd'

    # The id token's issuer
    config.token_iss = 'https://cognito-idp.ca-central-1.amazonaws.com/ca-central-1_exampleXyZ'
  end

  if Rails.env.production?
    # Admin Create Cognito User - URLS sent in welcome emails
    # ------------------------------------------------------------------------------------------------------------------

    config.client_activate_url = 'https://ermahgerd.io/login'
    config.client_forgot_password_url = 'https://ermahgerd.io/forgot-password'
    config.client_sign_in_url = 'https://ermahgerd.io/login'
  end
end
