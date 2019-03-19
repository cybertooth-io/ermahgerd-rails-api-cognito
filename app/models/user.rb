# frozen_string_literal: true

# The `User` model.  Email validations in effect.
class User < ApplicationRecord
  audited

  COGNITO = Aws::CognitoIdentityProvider::Client.new(stub_responses: Rails.env.test?).freeze

  # Ignore Removed Columns
  # --------------------------------------------------------------------------------------------------------------------

  self.ignored_columns = %w[first_name last_name nickname password_digest]

  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(:email)

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :email, presence: true

  validates :email, uniqueness: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :in_cognito, inclusion: { in: [true, false] }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_many :roles_users, dependent: :destroy

  has_many :roles, through: :roles_users

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
