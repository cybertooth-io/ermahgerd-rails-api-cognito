# frozen_string_literal: true

module Api
  module V1
    # A SINGULAR resource that is mapped to the CurrentUser model which is in turn a User record.
    # This is a singular resource by it's definition in routes.rb.
    class CurrentUserResource < JSONAPI::Resource
      include JSONAPI::Authorization::PunditScopedResource

      immutable # no CUD through controller

      # Singleton: http://jsonapi-resources.com/v0.9/guide/resources.html#Singleton-Resources
      # ----------------------------------------------------------------------------------------------------------------

      singleton singleton_key: lambda { |context|
        key = context[:current_user].try(:id)
        raise JSONAPI::Exceptions::RecordNotFound, nil if key.nil?

        key
      }

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
    end
  end
end
