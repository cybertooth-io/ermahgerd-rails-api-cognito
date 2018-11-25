# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class RolesControllerTest < ActionDispatch::IntegrationTest
      test 'when create' do
        post api_v1_roles_url, headers: auth(users(:some_administrator)), params: {
          data: {
            attributes: {
              key: 'CON',
              name: 'Contributor'
            },
            type: 'roles'
          }
        }.to_json

        assert_response :created
      end

      test 'when update' do
        role = roles(:guest)

        patch api_v1_role_url(role), headers: auth(users(:some_administrator)), params: {
          data: {
            attributes: {
              name: 'Guest Updated'
            },
            id: role.id,
            type: 'roles'
          }
        }.to_json

        assert_response :ok
      end

      test 'when relationships users' do
        role = roles(:guest)

        get api_v1_role_relationships_users_url(role), headers: auth(users(:some_administrator))

        assert_response :ok
      end

      test 'when role users' do
        role = roles(:guest)

        get api_v1_role_users_url(role), headers: auth(users(:some_administrator))

        assert_response :ok
      end
    end
  end
end
