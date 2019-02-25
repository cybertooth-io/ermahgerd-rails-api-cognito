# frozen_string_literal: true

# The `SessionActivity` model is used to track authenticated resource access by time, IP, and session.
class SessionActivity < ApplicationRecord
  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :path
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates(
    :access_token,
    :created_at,
    :ip_address,
    :jti,
    :path,
    :session,
    presence: true
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :session, touch: true

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  scope :by_jti, ->(jti) { where(jti: jti) }
end
