# frozen_string_literal: true

module Api
  module V1
    # This is a JSONAPI-Resources ready controller that tests authentication using Ermahgerd::Authorizer concern.
    # Authorization is managed through Pundit policies.
    class BaseJsonapiResourcesController < ApplicationController
      include Ermahgerd::AuthenticatedUser
      include Ermahgerd::Authorizer
      include JSONAPI::ActsAsResourceController
      include Pundit # included for Posterity sake should we override a controller and need to `authorize`

      # from the Ermahgerd::Authorizer concern ensuring valid `authenticated` requests
      before_action :authorize_request!

      # from the Ermahgerd::AuthenticatedUser concern that ensures the authenticated user is in the database
      before_action :assert_current_user!

      # got this far, let's attempt record this request in the `SessionActivity` table
      before_action :record_session_activity

      private

      # Using the setting in `config/initializers/ermahgerd.rb` determine whether or not to record session activity
      def record_session_activity
        return unless Ermahgerd.configuration.record_session_activity

        browser = Browser.new(request.headers['User-Agent'])

        RecordSessionActivityWorker.perform_async(
          browser.name,
          browser.full_version,
          Time.zone.now.iso8601,
          browser.device.name,
          request.remote_ip,
          Time.zone.at(access_token[:iat]).iso8601,
          access_token[:jti],
          request.path,
          browser.platform.name,
          browser.platform.version,
          current_user.id
        )
      end
    end
  end
end
