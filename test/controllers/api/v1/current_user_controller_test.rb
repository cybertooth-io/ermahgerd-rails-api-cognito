# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class CurrentUserControllerTest < ActionDispatch::IntegrationTest
      test 'when show without token' do
        get api_v1_current_user_url

        assert_response :unauthorized
      end

      test 'when show' do
        some_administrator = users(:some_administrator)

        get api_v1_current_user_url, headers: auth(some_administrator)

        assert_response :ok
        assert_equal some_administrator.id, JSON.parse(response.body)['data']['id'].to_i
      end
    end
  end
end
