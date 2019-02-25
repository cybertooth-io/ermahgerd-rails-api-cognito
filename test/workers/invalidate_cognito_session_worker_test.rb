# frozen_string_literal: true

require 'test_helper'

class InvalidateCognitoSessionWorkerTest < ActiveSupport::TestCase
  test 'when session id does not yield a session' do
    assert_raises ActiveRecord::RecordNotFound do
      InvalidateCognitoSessionWorker.new.perform(Time.zone.now.iso8601, users(:some_administrator).id, -1)
    end
  end

  test 'when Cognito errors to sign out' do
    User::COGNITO.stub_responses(
      :global_sign_out,
      Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException.new({}, 'Some Sort Of Error')
    )

    sterling = users(:sterling_archer)
    session = sterling.sessions.first

    assert_raises Aws::CognitoIdentityProvider::Errors::ResourceNotFoundException do
      InvalidateCognitoSessionWorker.new.perform(Time.zone.now.iso8601, sterling.id, session.id)
    end
  end

  test 'when session is invalidated' do
    User::COGNITO.stub_responses(:global_sign_out)

    sterling = users(:sterling_archer)
    session = sterling.sessions.first

    assert_changes -> { [session.reload.invalidated_at, session.reload.invalidated_by] } do
      InvalidateCognitoSessionWorker.new.perform(Time.zone.now.iso8601, sterling.id, session.id)
    end
  end
end
