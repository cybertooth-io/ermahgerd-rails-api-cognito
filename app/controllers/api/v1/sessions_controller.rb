# frozen_string_literal: true

module Api
  module V1
    # Simple JSONAPI controller that offers up all the basic actions.
    # This instance is special because it's `SessionsResource` is set to immutable so only read-only access
    # to the Session model will be provided through this controller.
    #
    # An `invalidate` action has been added to this controller.  This allows sessions to be destroyed
    # application-side for security reasons.
    class SessionsController < BaseJsonapiResourcesController
      def invalidate
        session = Session.find_by!(id: params[:id])

        authorize session

        InvalidateCognitoSessionWorker.perform_async(current_user.id, Time.zone.now.iso8601, session.id)

        render(status: :ok,
               json: JSONAPI::ResourceSerializer
            .new(Api::V1::SessionResource, base_url: base_url)
            .serialize_to_hash(Api::V1::SessionResource.new(session, context)))
      end
    end
  end
end
