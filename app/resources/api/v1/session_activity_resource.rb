# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `SessionActivity` model.
    # Removing the `updated_at` field from the fetchable fields because we're manually passing it in during creation.
    class SessionActivityResource < BaseResource
      immutable # no CUD through controller

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :ip_address,
        :path,
        # do not serialize the jti
        # do not serialize the access_token
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(_context)
        [] # immutable
      end

      def fetchable_fields
        super - [:updated_at]
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(_context)
        [] # immutable
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_one :session
    end
  end
end
