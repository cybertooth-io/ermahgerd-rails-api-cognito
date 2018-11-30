# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'json/jwt'
require 'rails/test_help'
require 'sidekiq/testing'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9'

    # Set up fake Sidekiq queuing (see https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing-fake)
    Sidekiq::Testing.fake!

    # Return time back to normal after each test case
    teardown do
      Timecop.return
    end

    def auth(user, aud = Ermahgerd.configuration.token_aud, exp = Time.zone.now.to_i, iss = Ermahgerd.configuration.token_iss, _options = {})
      Rails.logger.info '------------------------------------------------------------------------------------------'
      Rails.logger.info "AWS Cognito Token Authentication as #{user.email}"
      Rails.logger.info '------------------------------------------------------------------------------------------'

      @access_token = sign_access_token(access_payload(exp, user, iss))
      @id_token = sign_id_token(id_payload(exp, user, aud, iss))

      @headers = { 'Content-Type': JSONAPI::MEDIA_TYPE }
      @headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{@access_token}"
      @headers[Ermahgerd::HEADER_IDENTIFICATION] = @id_token.to_s
      @headers
    end

    private

    def sign_access_token(payload)
      sign_token(rsa_access_private_key, kid_access, payload)
    end

    def sign_id_token(payload)
      sign_token(rsa_id_private_key, kid_id, payload)
    end

    def sign_token(private_key, kid, payload)
      jwt_id = ::JSON::JWT.new(payload)
      jwt_id.alg = :RS256
      jwt_id.kid = kid
      jwt_id.sign(private_key)
    end

    def id_payload(now_in_seconds, user, aud, iss)
      {
        "aud": aud,
        "auth_time": now_in_seconds,
        "cognito:username": user.email,
        "email": user.email,
        "email_verified": true,
        "exp": now_in_seconds + 3600, # expires in an hour
        "iat": now_in_seconds,
        "iss": iss,
        "sub": 'aaaaaaaa-bbbb-cccc-dddd-example',
        "token_use": 'id'
      }
    end

    def access_payload(now_in_seconds, user, iss)
      {
        "auth_time": now_in_seconds,
        "exp": now_in_seconds + 3600, # expires in an hour
        "iat": now_in_seconds,
        "iss": iss,
        "jti": 'ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj',
        "scope": 'aws.cognito.signin.user.admin',
        "sub": 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
        "token_use": 'access',
        "username": user.email
      }
    end

    # Used exclusively in test environment for signing fake tokens
    def kid_id
      rsa_id_private_key.to_jwk[:kid]
    end

    # Used exclusively in test environment for signing fake tokens
    def kid_access
      rsa_access_private_key.to_jwk[:kid]
    end

    # Used exclusively in test environment for signing fake tokens
    def rsa_access_private_key
      @rsa_access_private_key ||= OpenSSL::PKey::RSA.new(File.read(Rails.root.join('config', 'test-access-private.key')))
    end

    # Used exclusively in test environment for signing fake tokens
    def rsa_id_private_key
      @rsa_id_private_key ||= OpenSSL::PKey::RSA.new(File.read(Rails.root.join('config', 'test-id-private.key')))
    end
  end
end
