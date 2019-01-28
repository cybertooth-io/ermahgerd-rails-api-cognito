# frozen_string_literal: true

# This worker is responsible for creating the user in the Cognito User Pool associated with this app.
class CreateCognitoUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find_by!(id: user_id)

    begin
      temporary_password = SecureRandom.base64(8)
      User::COGNITO.admin_create_user(
        message_action: 'SUPPRESS',
        temporary_password: temporary_password,
        user_pool_id: Rails.application.credentials.dig(:aws, :cognito, :user_pool_id),
        username: user.email
      )
      user.update!(in_cognito: true)
      InvitationsMailer.activate_new_account(user, temporary_password).deliver_now!
    rescue Aws::CognitoIdentityProvider::Errors::UsernameExistsException
      user.update!(in_cognito: true)
      InvitationsMailer.welcome_existing_user(user).deliver_now!
    end
  end
end
