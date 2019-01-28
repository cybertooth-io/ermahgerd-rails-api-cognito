# frozen_string_literal: true

require 'test_helper'

class CreateCognitoUserWorkerTest < ActiveSupport::TestCase
  test 'when Cognito refuses the temporary password' do
    User::COGNITO.stub_responses(
      :admin_create_user,
      Aws::CognitoIdentityProvider::Errors::InvalidPasswordException.new({}, 'InvalidPasswordException')
    )

    assert_no_difference ['ActionMailer::Base.deliveries.size'] do
      assert_raises Aws::CognitoIdentityProvider::Errors::InvalidPasswordException do
        CreateCognitoUserWorker.new.perform(users(:some_guest).id)
      end
    end
  end

  test 'when Cognito already has the user' do
    User::COGNITO.stub_responses(
      :admin_create_user,
      Aws::CognitoIdentityProvider::Errors::UsernameExistsException.new({}, 'UsernameExistsException')
    )

    assert_difference ['ActionMailer::Base.deliveries.size', 'User::COGNITO.api_requests.size'] do
      email = CreateCognitoUserWorker.new.perform(users(:some_guest).id)
      assert_equal I18n.t('invitations_mailer.welcome_existing_user.subject'), email.subject
    end
  end

  test 'when Cognito creates the new user' do
    User::COGNITO.stub_responses(:admin_create_user)

    assert_difference ['ActionMailer::Base.deliveries.size', 'User::COGNITO.api_requests.size'] do
      email = CreateCognitoUserWorker.new.perform(users(:some_guest).id)
      assert_equal I18n.t('invitations_mailer.activate_new_account.subject'), email.subject
    end
  end
end
