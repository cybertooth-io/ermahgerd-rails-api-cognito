# frozen_string_literal: true

require 'test_helper'

class InvitationsMailerTest < ActionMailer::TestCase
  test 'when activate new account email' do
    mail = InvitationsMailer.activate_new_account(users(:some_guest), 'someTemporaryPassword')
    assert_equal I18n.t('invitations_mailer.activate_new_account.subject'), mail.subject
  end

  test 'when welcome existing user email' do
    mail = InvitationsMailer.welcome_existing_user(users(:some_guest))
    assert_equal I18n.t('invitations_mailer.welcome_existing_user.subject'), mail.subject
  end

  test 'set_password' do
    skip 'DESTROY THIS EMAIL'
    mail = InvitationsMailer.set_password
    assert_equal 'Invitation - Set Your Password', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
