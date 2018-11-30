# frozen_string_literal: true

require 'test_helper'

class AccessTokenVerificationsControllerTest < ActionDispatch::IntegrationTest
  test 'when access token is not supplied' do
    headers = auth(users(:some_administrator))

    assert headers.key?(Ermahgerd::HEADER_AUTHORIZATION)
    headers.except!(Ermahgerd::HEADER_AUTHORIZATION)
    assert_not headers.key?(Ermahgerd::HEADER_AUTHORIZATION)

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ACCESS token is not found', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when access token has been tampered with' do
    headers = auth(users(:some_administrator))

    headers[Ermahgerd::HEADER_AUTHORIZATION] = 'Bearer x.y.z'

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'Invalid ACCESS token', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when access token cannot be decoded' do
    headers = auth(users(:some_administrator))

    junk_token = ::JSON::JWT.new(some: 'garbage').sign(OpenSSL::PKey::RSA.generate(2048))
    headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{junk_token}"

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'Invalid ACCESS token', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when access token iss claim is missing' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = access_payload(Time.zone.now.to_i, some_administrator, nil)
    headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{sign_access_token(payload)}"

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ACCESS token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when access token iss claim is incorrect' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = access_payload(Time.zone.now.to_i, some_administrator, 'abc')
    headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{sign_access_token(payload)}"

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ACCESS token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when the access token is missing the jti claim' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = access_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_iss).except!(:jti)
    headers[Ermahgerd::HEADER_AUTHORIZATION] = "Bearer #{sign_access_token(payload)}"

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ACCESS token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when the access token is expired' do
    Timecop.freeze

    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    get api_v1_roles_url, headers: headers
    assert_response :ok

    Timecop.travel(
      (Ermahgerd.configuration.access_token_expire_seconds + Ermahgerd.configuration.access_token_leeway_seconds)
        .seconds.from_now
    )

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'Signature has expired', JSON.parse(response.body)['errors'].first['detail']
  end
end
