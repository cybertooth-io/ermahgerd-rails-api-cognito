# frozen_string_literal: true

module Ermahgerd
  module Controllers
    module Concerns
      # Controller concern that can be used to provide a `current_user` method that will return a reference to
      # the authenticated `User` instance whose `Role` relations are included.
      #
      # The `User` instance is placed in the `@current_user` member variable.
      #
      # There is nothing stopping an implementor from changing this to return a JSON representation
      # of this user that is stored inside the JWT access token.
      module AuthenticatedUser
        extend ActiveSupport::Concern
        included do
          private

          # See https://github.com/cybertooth-io/ermahgerd-rails-api-cognito/issues/10
          def assert_current_user!
            raise ActiveRecord::RecordNotFound, 'Authenticated user not found in API server' if current_user.nil?
          end

          # The current_user can be found from the email address in the token payloard
          # Eagerly load the user's roles so they can be discriminated against
          def current_user
            @current_user ||= CurrentUser.includes(:roles).find_by(email: id_token[:email])
          end

          # In JSONAPI the `context` function returns a hash that is available at every lifecycle moments in the JSONAPI
          # implementation.  For Pundit in particular, it needs the current_user in order to authorize access to
          # controller actions.
          def context
            { controller: self, current_user: current_user }
          end
        end
      end
    end
  end
end
