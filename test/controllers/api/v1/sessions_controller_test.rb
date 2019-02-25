# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test 'when invalidate' do
        session = sessions(:sterling_archer_session)

        assert_difference ['InvalidateCognitoSessionWorker.jobs.size'] do
          patch invalidate_api_v1_session_url(session),
                headers: auth(users(:some_administrator)),
                params: {
                  data: {
                    id: session.id,
                    type: 'sessions'
                  }
                }.to_json
        end

        assert_response :ok
      end

      test 'when index and include last session activity' do
        get api_v1_sessions_url, headers: auth(users(:some_administrator)), params: {
          include: 'last-session-activity'
        }

        assert_response :ok
      end

      test 'when index and include all session activities' do
        get api_v1_sessions_url, headers: auth(users(:some_administrator)), params: {
          include: 'session-activities'
        }

        assert_response :ok
      end

      test 'when index' do
        get api_v1_sessions_url, headers: auth(users(:some_administrator))

        assert_response :ok
      end
    end
  end
end
