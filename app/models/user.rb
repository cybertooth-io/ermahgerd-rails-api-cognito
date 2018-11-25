# frozen_string_literal: true

# The `User` model.  Email validations in effect.
class User < ApplicationRecord
  audited

  # Ignore Removed Columns
  # --------------------------------------------------------------------------------------------------------------------

  self.ignored_columns = ['password_digest']

  # Callbacks
  # --------------------------------------------------------------------------------------------------------------------

  before_destroy do
    roles.clear
  end

  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :email,
    :first_name,
    :last_name,
    :nickname
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :email, :first_name, :last_name, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :roles
  # rubocop:enable Rails/HasAndBelongsToMany

  has_many :sessions, dependent: :restrict_with_error

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  # Pundit Helpers
  # --------------------------------------------------------------------------------------------------------------------

  def administrator?
    roles.exists?(key: 'ADMIN')
  end

  def guest?
    roles.exists?(key: 'GUEST')
  end
end
