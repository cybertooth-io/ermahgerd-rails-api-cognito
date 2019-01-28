# frozen_string_literal: true

# A `Session` represents all of the sign in information collected from an authenticated user.
class Session < ApplicationRecord
  # Ignore Removed Columns
  # --------------------------------------------------------------------------------------------------------------------

  self.ignored_columns = %w[expiring_at invalidated jti ruid]

  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :browser,
    :browser_version,
    :device,
    :platform,
    :platform_version
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates(
    :authenticated_at,
    :browser,
    :browser_version,
    :device,
    :device_key,
    :ip_address,
    :platform,
    :platform_version,
    :user,
    presence: true
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :invalidated_by, class_name: 'User', optional: true

  belongs_to :user, touch: true

  has_many :session_activities, dependent: :destroy

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  scope :by_jti, ->(jti) { joins(:session_activities).merge(SessionActivity.by_jti(jti)) }

  scope :by_user, ->(ids) { where user_id: ids }
end
