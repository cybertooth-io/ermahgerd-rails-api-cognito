# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # Sidekiq Console
  # RTFM: https://github.com/mperham/sidekiq/wiki/Monitoring#rails
  mount Sidekiq::Web => '/sidekiq'

  post '/cookie/login', to: 'cookie_authentications#create'
  delete '/cookie/logout', to: 'cookie_authentications#destroy'
  post '/cookie/logout', to: 'cookie_authentications#destroy'
  post '/cookie/refresh', to: 'refresh_cookies#create'
  post '/token/login', to: 'token_authentications#create'
  delete '/token/logout', to: 'token_authentications#destroy'
  post '/token/logout', to: 'token_authentications#destroy'
  post '/token/refresh', to: 'refresh_tokens#create'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      jsonapi_resource :current_user, except: %i[create destroy]
      jsonapi_resources :roles
      jsonapi_resources :session_activities
      jsonapi_resources :sessions
      jsonapi_resources :users
    end
  end
end
