# frozen_string_literal: true

# This worker is responsible for attempting to invalidate an identified session using AWS-SDK and the
# access token from the user.
class InvalidateCognitoSessionWorker
  include Sidekiq::Worker

  def perform(invalidated_at_iso8601, performed_by_id, session_id)
    invalidated_at = Time.zone.parse(invalidated_at_iso8601)
    invalidated_by = User.find_by(id: performed_by_id) # if user isn't found oh well, nil will be placed in the record
    session = Session.find_by! id: session_id

    # COGNITO could throw an exception; Sidekiq will retry
    User::COGNITO.global_sign_out(access_token: session.last_session_activity.access_token)
    session.update!(invalidated_at: invalidated_at, invalidated_by: invalidated_by)
  end
end
