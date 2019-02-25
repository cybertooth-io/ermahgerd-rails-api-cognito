# frozen_string_literal: true

# The `Role` model is linked to the `User` model such that a user can belong to many roles.  Roles will be used
# by Pundit policies to determine whether the user in question is authorized (not authenticated) to execute
# a specific controller action.
class Role < ApplicationRecord
  audited

  # Callbacks
  # --------------------------------------------------------------------------------------------------------------------

  before_validation do
    self.key = key.upcase if key.present?
  end

  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :key,
    :name,
    :notes
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :key, :name, presence: true

  validates :key, uniqueness: { case_sensitive: false }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_many :roles_users, dependent: :destroy

  has_many :users, through: :roles_users

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------
end
