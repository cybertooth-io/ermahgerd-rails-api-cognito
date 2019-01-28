# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `User` model.
    # It should go without saying that the password_digest is never passed through the wire.
    # :password & :password_confirmation will be accepted on create and update but will never be sent back through
    # the wire.
    class UserResource < BaseResource
      # Callbacks
      # ----------------------------------------------------------------------------------------------------------------

      after_create do
        CreateCognitoUserWorker.perform_async(@model.id) if context[:controller].action_name == 'create'
      end

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :email,
        :in_cognito,
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(context)
        super
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(context)
        super
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_many :roles
      has_many :sessions
    end
  end
end
