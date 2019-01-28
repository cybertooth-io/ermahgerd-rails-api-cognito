# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Sidekiq Console
  # RTFM: https://github.com/mperham/sidekiq/wiki/Monitoring#rails
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      jsonapi_resource :current_user do
        jsonapi_relationships
        patch :sign_out, path: 'sign-out'
        put :sign_out, path: 'sign-out'
      end
      jsonapi_resources :roles
      jsonapi_resources :session_activities
      jsonapi_resources :sessions
      jsonapi_resources :users
    end
  end
end
