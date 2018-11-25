# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test 'when attempting to access the index action without authorization header' do
        get api_v1_users_url

        assert_response :unauthorized
      end

      test 'when attempting to access to the index action with authorization header' do
        get api_v1_users_url, headers: auth(users(:some_administrator))

        assert_response :ok
        assert_equal 5, ::JSON.parse(response.body)['data'].length
      end

      test 'when accessing resource a few seconds before token expires' do
        Timecop.freeze

        auth(users(:some_administrator))

        Timecop.travel((Rails.configuration.access_token_expire_seconds - 3).seconds.from_now)

        get api_v1_users_url, headers: @headers

        assert_response :ok
        assert_equal 5, ::JSON.parse(response.body)['data'].length
      end

      test 'when accessing resource a few seconds after access token expires' do
        Timecop.freeze

        auth(users(:some_administrator))

        Timecop.travel((Rails.configuration.access_token_expire_seconds + Rails.configuration.access_token_leeway_seconds + 3).seconds.from_now)

        get api_v1_users_url, headers: @headers

        assert_response :unauthorized
        assert_equal 'Signature has expired', ::JSON.parse(response.body)['errors'].first['detail']
      end

      test 'when show' do
        get api_v1_user_url(users(:mallory_archer)), headers: auth(users(:some_administrator))

        assert_response :ok
        assert_equal 'mallory@isiservice.com', ::JSON.parse(response.body)['data']['attributes']['email']
      end

      test 'when destroy by a permitted user' do
        assert_difference ['User.count'], -1 do
          delete api_v1_user_url(users(:mallory_archer)), headers: auth(users(:some_administrator))
        end

        assert_response :no_content
      end
    end
  end
end
