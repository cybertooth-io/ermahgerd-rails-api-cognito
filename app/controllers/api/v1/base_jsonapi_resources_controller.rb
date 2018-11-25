# frozen_string_literal: true

module Api
  module V1
    # This is a JSONAPI-Resources ready controller that tests authentication using CognitoAuthorizer concern.
    # Authorization is managed through Pundit policies.
    class BaseJsonapiResourcesController < ApplicationController
      include CurrentUser
      include JSONAPI::ActsAsResourceController
      include CognitoAuthorizer
      include Pundit

      # :authorize_request! is from the CognitoAuthorizer concern ensuring valid `authenticated` requests
      before_action :authorize_request!

      private

      # In JSONAPI the `context` function returns a hash that is available at every lifecycle moments in the JSONAPI
      # implementation.  For Pundit in particular, it needs the current_user in order to authorize access to
      # controller actions.
      def context
        { current_user: current_user }
      end
    end
  end
end
