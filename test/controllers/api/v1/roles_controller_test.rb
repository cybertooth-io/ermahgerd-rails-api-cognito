# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class RolesControllerTest < ActionDispatch::IntegrationTest
      test 'when create' do
        assert_difference ['Role.count'] do
          post api_v1_roles_url, headers: auth(users(:some_administrator)), params: {
            data: {
              attributes: {
                key: 'CON',
                name: 'Contributor'
              },
              type: 'roles'
            }
          }.to_json
        end

        assert_response :created
      end

      test 'when create forbidden' do
        assert_no_difference ['Role.count'] do
          post api_v1_roles_url, headers: auth(users(:some_guest)), params: {
            data: {
              attributes: {
                key: 'CON',
                name: 'Contributor'
              },
              type: 'roles'
            }
          }.to_json
        end

        assert_response :forbidden
      end

      test 'when delete' do
        role = Role.create!(key: 'CON', name: 'Contributor')

        assert_difference ['Role.count'], -1 do
          delete api_v1_role_url(role), headers: auth(users(:some_administrator))
        end

        assert_response :no_content
      end

      test 'when delete forbidden' do
        role = Role.create!(key: 'CON', name: 'Contributor')

        assert_no_difference ['Role.count'] do
          delete api_v1_role_url(role), headers: auth(users(:some_guest))
        end

        assert_response :forbidden
      end

      test 'when index' do
        get api_v1_roles_url, headers: auth(users(:some_administrator))

        assert_response :ok
        assert_equal Role.all.count, JSON.parse(response.body)['data'].length
      end

      test 'when index forbidden' do
        get api_v1_roles_url, headers: auth(users(:some_guest))

        assert_response :forbidden
      end

      test 'when show' do
        role_guest = roles(:guest)

        get api_v1_role_url(role_guest), headers: auth(users(:some_administrator))

        assert_response :ok
        assert_equal role_guest.id, JSON.parse(response.body)['data']['id'].to_i
      end

      test 'when show forbidden' do
        get api_v1_role_url(roles(:guest)), headers: auth(users(:some_guest))

        assert_response :forbidden
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

      test 'when update forbidden' do
        role = roles(:guest)

        patch api_v1_role_url(role), headers: auth(users(:some_guest)), params: {
          data: {
            attributes: {
              name: 'Guest Updated'
            },
            id: role.id,
            type: 'roles'
          }
        }.to_json

        assert_response :forbidden
      end

      test 'when index relationships users' do
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
