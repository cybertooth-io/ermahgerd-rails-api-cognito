# frozen_string_literal: true

# A `Session` represents all of the sign in information collected from an authenticated user.
class Session < ApplicationRecord
  # Ignore Removed Columns
  # --------------------------------------------------------------------------------------------------------------------

  self.ignored_columns = ['ruid']

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
    :browser,
    :browser_version,
    :device,
    :expiring_at,
    :ip_address,
    :platform,
    :platform_version,
    :user,
    presence: true
  )

  validates(
    :invalidated_by,
    presence: true,
    on: :update
  )

  # boolean presence check...crazy I know (http://stackoverflow.com/a/4721574/545137)
  validates :invalidated, inclusion: { in: [true, false] }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :invalidated_by, class_name: 'User', optional: true

  belongs_to :user

  has_many :session_activities, dependent: :destroy

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  scope :by_user, ->(ids) { where user_id: ids }
end
