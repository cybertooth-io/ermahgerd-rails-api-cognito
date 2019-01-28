# frozen_string_literal: true

module Api
  module V1
    # The current user controller is bound as a SINGULAR route (no index).
    # After a successful `show` action has resulted we will spin up a session job
    class CurrentUserController < BaseJsonapiResourcesController
      def sign_out
        InvalidateSessionWorker.perform_async(
          current_user.id,
          Time.zone.now.iso8601,
          access_token[:jti]
        )

        render json: {}, status: :no_content
      end
    end
  end
end
