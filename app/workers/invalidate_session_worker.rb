# frozen_string_literal: true

# This worker is responsible for setting the `Session`s `invalidated_at` and `invalidated_by` column
# when someone triggers the session sign out.
class InvalidateSessionWorker
  include Sidekiq::Worker

  def perform(performed_by_id, invalidated_at_iso8601, jti)
    invalidated_at = Time.zone.parse(invalidated_at_iso8601)
    invalidated_by = User.find_by(id: performed_by_id) # if user isn't found, oh well

    ActiveRecord::Base.transaction do
      Session.by_jti(jti).by_distinct.each do |session|
        session.update!(invalidated_at: invalidated_at, invalidated_by: invalidated_by)
      end
    end
  end
end
