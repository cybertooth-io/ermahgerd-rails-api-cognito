# frozen_string_literal: true

JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Ermahgerd::Errors::Unauthorized, Pundit::NotAuthorizedError]

  # Metadata
  # Output record count in top level meta for find operation

  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count
end
