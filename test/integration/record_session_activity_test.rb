# frozen_string_literal: true

require 'test_helper'

class RecordSessionActivityTest < ActionDispatch::IntegrationTest
  teardown do
    Ermahgerd.configuration.record_session_activity = true
  end

  test 'when session activity is turned on the job is fired during an authenticated request' do
    Ermahgerd.configuration.record_session_activity = true

    assert Ermahgerd.configuration.record_session_activity

    assert_difference ['RecordSessionActivityWorker.jobs.size'] do
      get api_v1_roles_url, headers: auth(users(:some_administrator))
    end

    assert_response :ok
  end

  test 'when session activity is turned ON but the session is not authenticated the job is not fired' do
    Ermahgerd.configuration.record_session_activity = true

    assert Ermahgerd.configuration.record_session_activity

    assert_no_difference ['RecordSessionActivityWorker.jobs.size'] do
      get api_v1_roles_url
    end

    assert_response :unauthorized
  end

  test 'when session activity is turned OFF the job is not fired during an authenticated request' do
    Ermahgerd.configuration.record_session_activity = false

    assert_not Ermahgerd.configuration.record_session_activity

    assert_no_difference ['RecordSessionActivityWorker.jobs.size'] do
      get api_v1_roles_url, headers: auth(users(:some_administrator))
    end

    assert_response :ok
  end
end
