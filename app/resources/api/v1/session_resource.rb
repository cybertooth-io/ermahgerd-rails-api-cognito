# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `Session` model.
    class SessionResource < BaseResource
      immutable # no CUD through controller except :invalidate (which is hand-coded)

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :authenticated_at,
        :browser,
        :browser_version,
        :device,
        :expires_at,
        :invalidated_at,
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

      has_one :invalidated_by

      has_one :last_session_activity, foreign_key_on: :related

      has_many :session_activities

      has_one :user

      # Filters
      # ----------------------------------------------------------------------------------------------------------------

      filter :user
    end
  end
end
