# frozen_string_literal: true

# Controller that all generated Controllers inherit from.
# The CognitoAuthorizer will provide an `:authorize_request!` hook to ensure supplied tokens are valid.
#
# This controller is configured to rescue from the following errors:
# 1. ActiveRecord::RecordNotFound - that way you can Model.find_by! and have the controller handle the error
# 2. Ermahgerd::Errors::Unauthorized - any unauthorized access comes here for processing
#
# Errors will be serialized to match the JSONAPI specification: https://jsonapi.org/format/#document-top-level &
# https://jsonapi.org/format/#errors
#
# The `current_user` method will get a reference to the authenticated `User` instance.
class ApplicationController < ActionController::API
  include RescueFromForbidden
  include RescueFromRecordNotFound
  include RescueFromUnauthorized
end
