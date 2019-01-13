# frozen_string_literal: true

require 'test_helper'

class IdTokenVerificationsTest < ActionDispatch::IntegrationTest
  test 'when id token is not supplied' do
    headers = auth(users(:some_administrator))

    assert headers.key?(Ermahgerd::HEADER_IDENTIFICATION)
    headers.except!(Ermahgerd::HEADER_IDENTIFICATION)
    assert_not headers.key?(Ermahgerd::HEADER_IDENTIFICATION)

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token is not found', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token has been tampered with' do
    headers = auth(users(:some_administrator))

    headers[Ermahgerd::HEADER_IDENTIFICATION] = 'x.y.z'

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'Invalid ID token', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token cannot be decoded' do
    headers = auth(users(:some_administrator))

    junk_token = ::JSON::JWT.new(some: 'garbage').sign(OpenSSL::PKey::RSA.generate(2048))
    headers[Ermahgerd::HEADER_IDENTIFICATION] = junk_token

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'Invalid ID token', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token aud claim is missing' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, nil, Ermahgerd.configuration.token_iss)
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token aud claim is incorrect' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_aud + 'abc', Ermahgerd.configuration.token_iss)
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token iss claim is missing' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_aud, nil)
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when id token iss claim is incorrect' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_aud, Ermahgerd.configuration.token_iss + 'abc')
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when email claim is missing' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_aud, Ermahgerd.configuration.token_iss)
    payload = payload.except!(:email)
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when sub claim is missing' do
    some_administrator = users(:some_administrator)
    headers = auth(some_administrator)

    payload = id_payload(Time.zone.now.to_i, some_administrator, Ermahgerd.configuration.token_aud, Ermahgerd.configuration.token_iss)
    payload = payload.except!(:sub)
    headers[Ermahgerd::HEADER_IDENTIFICATION] = sign_id_token(payload).to_s

    get api_v1_roles_url, headers: headers

    assert_response :unauthorized
    assert_equal 'ID token claim is invalid', JSON.parse(response.body)['errors'].first['detail']
  end
end
