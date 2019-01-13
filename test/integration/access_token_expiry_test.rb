# frozen_string_literal: true

require 'test_helper'

class AccessTokenExpiryTest < ActionDispatch::IntegrationTest
  teardown do
    Ermahgerd.configuration.access_token_leeway_seconds = 0
  end

  test 'when accessing resource a few seconds before token expires' do
    Timecop.freeze

    auth(users(:some_administrator))

    Timecop.travel((Ermahgerd.configuration.access_token_expire_seconds - 3).seconds.from_now)

    get api_v1_roles_url, headers: @headers

    assert_response :ok
  end

  test 'when accessing resource a few seconds after access token expires' do
    Timecop.freeze

    auth(users(:some_administrator))

    Timecop.travel((Ermahgerd.configuration.access_token_expire_seconds + Ermahgerd.configuration.access_token_leeway_seconds + 3).seconds.from_now)

    get api_v1_roles_url, headers: @headers

    assert_response :unauthorized
    assert_equal 'Signature has expired', ::JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when accessing resource 15 seconds after access token expires with 30 second leeway' do
    Ermahgerd.configuration.access_token_leeway_seconds = 30

    Timecop.freeze

    auth(users(:some_administrator))

    Timecop.travel((Ermahgerd.configuration.access_token_expire_seconds + 15).seconds.from_now)

    get api_v1_roles_url, headers: @headers

    assert_response :ok
  end

  test 'when accessing resource 33 seconds after access token expires with 30 second leeway' do
    Ermahgerd.configuration.access_token_leeway_seconds = 30

    Timecop.freeze

    auth(users(:some_administrator))

    Timecop.travel((Ermahgerd.configuration.access_token_expire_seconds + 33).seconds.from_now)

    get api_v1_roles_url, headers: @headers

    assert_response :unauthorized
    assert_equal 'Signature has expired', ::JSON.parse(response.body)['errors'].first['detail']
  end
end
