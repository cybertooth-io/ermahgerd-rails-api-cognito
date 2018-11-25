# frozen_string_literal: true

require 'json/jwt'

# The AWS Cognito token is decoded and verified and then used in before controller hooks to determine
# whether requests are from an authenticated source.
module CognitoAuthorizer
  extend ActiveSupport::Concern
  # rubocop:disable Metrics/BlockLength
  included do
    private

    # Use to authorize that the
    def authorize_request!
      token = id_token
      raise Ermahgerd::ClaimsVerification, 'Claim is invalid' unless
      token[:aud] == Rails.configuration.token_aud &&
      token[:email].present? &&
      token[:iss] == Rails.configuration.token_iss &&
      token[:sub].present?

      raise Ermahgerd::Errors::SignatureExpired, 'Signature has expired' unless
        Time.zone.at(token[:exp] + Rails.configuration.access_token_leeway_seconds) > Time.zone.now
    end

    # Will raise JSON::JWT::VerificationFailed if the token doesn't decode
    def id_token
      @id_token ||= JSON::JWT.decode(token_from_header, JSON::JWK::Set.new(jwk_set))
    rescue JSON::JWT::VerificationFailed
      Rails.logger.error 'Token could not be decoded; possible key set issue or just an invalid token'
      raise Ermahgerd::Errors::Unauthorized 'Invalid token'
    end

    # The key set from Cognito; should be in your secrets as `jwk_set`
    # https://cognito-idp.{region}.amazonaws.com/{userPoolId}/.well-known/jwks.json
    # NOTE ABOUT TESTING: we've created our own RSA private keys and public key sets
    def jwk_set
      return JSON.parse(File.read(Rails.root.join('config', 'test-jwk-set.json'))) if Rails.env.test?

      JSON.parse(Rails.application.credentials.dig(:jwk_set))
    end

    # Using Rails 5's request.headers
    def token_from_header
      raw_token = request.headers[Ermahgerd::HEADER_AUTHORIZATION] || ''
      token = raw_token.split(' ')[-1]
      raise Ermahgerd::Errors::Unauthorized, 'Token is not found' unless token

      token
    end
  end
  # rubocop:enable Metrics/BlockLength
end
