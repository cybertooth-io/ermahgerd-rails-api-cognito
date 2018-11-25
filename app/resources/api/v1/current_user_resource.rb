# frozen_string_literal: true

module Api
  module V1
    # A SINGULAR resource that is mapped to the CurrentUser model which is in turn a User record.
    # This is a singular resource by it's definition in routes.rb.
    class CurrentUserResource < JSONAPI::Resource
      include JSONAPI::Authorization::PunditScopedResource

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :created_at,
        :email,
        :updated_at,
        {}
      )

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_many :roles
      has_many :sessions

      # Overrides
      # ----------------------------------------------------------------------------------------------------------------

      def self.find_by_key(_key, options = {})
        context = options[:context]
        new(CurrentUser.find_by(id: context[:current_user].id), context)
      end
    end
  end
end
