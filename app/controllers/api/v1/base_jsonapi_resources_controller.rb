# frozen_string_literal: true

module Api
  module V1
    # This is a JSONAPI-Resources ready controller that tests authentication using CognitoAuthorizer concern.
    # Authorization is managed through Pundit policies.
    class BaseJsonapiResourcesController < ApplicationController
      include Ermahgerd::CurrentUser
      include JSONAPI::ActsAsResourceController
      include CognitoAuthorizer
      include Pundit # included for Posterity sake should we override a controller and need to `authorize`

      # :authorize_request! is from the CognitoAuthorizer concern ensuring valid `authenticated` requests
      before_action :authorize_request!

      # got this far, let's record this request in the `SessionActivity` table
      before_action :record_session_activity

      private

      # Using the setting in `config/application.rb` determine whether or not to record session activity
      def record_session_activity
        return unless Rails.configuration.record_session_activity

        # TODO: we need to use the `jti` from the token
        # TODO: See https://en.wikipedia.org/wiki/JSON_Web_Token#Standard_fields
        # ruid = payload['ruid']
        # session = Session.find_by!(ruid: ruid)
        #
        # if session.present?
        #   return RecordSessionActivityWorker.perform_async(
        #     Time.zone.now.iso8601,
        #     request.remote_ip,
        #     request.path,
        #     session.id
        #   )
        # end
        #
        # Rails.logger.warn("Session with ruid of #{ruid} cannot be found.")
      end
    end
  end
end
