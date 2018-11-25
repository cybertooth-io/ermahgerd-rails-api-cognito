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

    def auth(user, _options = {})
      Rails.logger.info '------------------------------------------------------------------------------------------'
      Rails.logger.info "AWS Cognito Token Authentication as #{user.email}"
      Rails.logger.info '------------------------------------------------------------------------------------------'

      now_in_seconds = Time.zone.now.to_i

      jwt_id = ::JSON::JWT.new(id_payload(now_in_seconds, user))
      jwt_id.alg = :RS256
      jwt_id.kid = kid_id
      @id_token = jwt_id.sign(rsa_id_private_key)

      jwt_access = ::JSON::JWT.new(access_payload(now_in_seconds))
      jwt_access.alg = :RS256
      jwt_access.kid = kid_access
      @access_token = jwt_access.sign(rsa_access_private_key)

      @headers = { 'Content-Type': JSONAPI::MEDIA_TYPE }
      @headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{@id_token}"
      @headers
    end

    private

    def id_payload(now_in_seconds, user)
      {
        "aud": Rails.configuration.token_aud,
        "auth_time": now_in_seconds,
        "cognito:username": user.email,
        "email": user.email,
        "email_verified": true,
        "exp": now_in_seconds + 3600, # expires in an hour
        "iat": now_in_seconds,
        "iss": Rails.configuration.token_iss,
        "sub": 'aaaaaaaa-bbbb-cccc-dddd-example',
        "token_use": 'id'
      }
    end

    def access_payload(now_in_seconds)
      {
        "auth_time": now_in_seconds,
        "exp": now_in_seconds + 3600, # expires in an hour
        "iat": now_in_seconds,
        "iss": Rails.configuration.token_iss,
        "scope": 'aws.cognito.signin.user.admin',
        "sub": 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
        "token_use": 'access',
        "username": 'janedoe@example.com'
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
