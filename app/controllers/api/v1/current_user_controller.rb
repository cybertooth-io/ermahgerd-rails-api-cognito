# frozen_string_literal: true

module Api
  module V1
    # The current user controller is bound as a SINGULAR route (no index).
    # After a successful `show` action has resulted we will spin up a session job
    class CurrentUserController < BaseJsonapiResourcesController
      after_action :create_session, only: [:show]

      # Simply declaring this action because Rubocop wanted it here because the `after_action` uses it on its `only`
      def show
        super
      end

      private

      def create_session
        # record `Session` information here (including browser, etc.)
        # TODO
      end
    end
  end
end
