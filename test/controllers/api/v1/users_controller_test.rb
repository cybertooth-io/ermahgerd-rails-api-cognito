# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test 'when create user fails, Cognito is not called and nothing changes' do
        assert_no_difference ['CreateCognitoUserWorker.jobs.size', 'User.count'] do
          post api_v1_users_url, headers: auth(users(:some_administrator)), params: { data: {
            attributes: {},
            type: 'users'
          } }.to_json
        end

        assert_response :unprocessable_entity
      end

      test 'when create user in Cognito and in app database' do
        assert_difference ['CreateCognitoUserWorker.jobs.size', 'User.count'] do
          post api_v1_users_url, headers: auth(users(:some_administrator)), params: {
            data: {
              attributes: {
                email: 'some@email.com'
              },
              type: 'users'
            }
          }.to_json
        end

        assert_response :created
      end

      test 'when create user with a role' do
        guest_role = roles(:guest)
        assert_difference ['CreateCognitoUserWorker.jobs.size', 'guest_role.users.count', 'User.count'] do
          post api_v1_users_url, headers: auth(users(:some_administrator)), params: {
            data: {
              attributes: {
                email: 'some@email.com'
              },
              relationships: {
                roles: { data: [{ id: guest_role.id, type: 'roles' }] }
              },
              type: 'users'
            }
          }.to_json

          assert_response :created
        end
      end
    end
  end
end
