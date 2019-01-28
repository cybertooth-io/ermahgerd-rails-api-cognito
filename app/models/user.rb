# frozen_string_literal: true

# The `User` model.  Email validations in effect.
class User < ApplicationRecord
  audited

  COGNITO = Aws::CognitoIdentityProvider::Client.new(stub_responses: Rails.env.test?).freeze

  # Ignore Removed Columns
  # --------------------------------------------------------------------------------------------------------------------

  self.ignored_columns = %w[first_name last_name nickname password_digest]

  # Callbacks
  # --------------------------------------------------------------------------------------------------------------------

  # HABTM doesn't support `dependent: :destroy` so you have to do this manually
  before_destroy do
    roles.clear
  end

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
