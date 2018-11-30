# frozen_string_literal: true

Ermahgerd.configure do |config|
  if Rails.env.test?
    # Cognito Token Verification Configuration
    # ------------------------------------------------------------------------------------------------------------------

    # The id token's audience
    config.token_aud = 'ermahgerd'

    # The id token's issuer
    config.token_iss = 'https://cognito-idp.ca-central-1.amazonaws.com/ca-central-1_exampleXyZ'
  end
end
