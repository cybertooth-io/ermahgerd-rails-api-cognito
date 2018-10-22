# frozen_string_literal: true

# A `Session` represents all of the sign in information collected from an authenticated user.
# The `RUID` is what binds the session information stored in the database with what is stored inside of Redis
# by `JWTSessions`.
class Session < ApplicationRecord
  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates(
    :browser,
    :browser_version,
    :device,
    :expiring_at,
    :ip_address,
    :platform,
    :platform_version,
    :ruid,
    :user,
    presence: true
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :invalidated_by, class_name: 'User', optional: true

  belongs_to :user
end
