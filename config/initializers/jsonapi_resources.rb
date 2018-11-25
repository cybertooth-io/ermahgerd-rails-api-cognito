# frozen_string_literal: true

JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Ermahgerd::Errors::Unauthorized, Pundit::NotAuthorizedError]
end
