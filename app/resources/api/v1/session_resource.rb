# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `Session` model.
    class SessionResource < BaseResource
      immutable # no CUD through controller

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :browser,
        :browser_version,
        :device,
        :expiring_at,
        :invalidated,
        :ip_address,
        :platform,
        :platform_version,
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(_context)
        [] # immutable
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(_context)
        [] # immutable
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_one :user
    end
  end
end
