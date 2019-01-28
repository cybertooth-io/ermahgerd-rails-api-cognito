# frozen_string_literal: true

# A mailer used in relation to inviting users to the system.
# TODO: this is not a valid mailer use case and is being used for testing bootstrap mail
class InvitationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml with the following lookup:
  #   invitations_mailer.activate_new_account.subject
  def activate_new_account(user, temporary_password)
    @hash = { temporary_password: temporary_password, user: user }

    make_bootstrap_mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml with the following lookup:
  #   invitations_mailer.set_password.subject
  # TODO: destroy this email & it's html/text files
  def set_password
    @greeting = 'Hi'

    make_bootstrap_mail to: 'to@example.org'
  end

  # Subject can be set in your I18n file at config/locales/en.yml with the following lookup:
  #   invitations_mailer.welcome_existing_user.subject
  def welcome_existing_user(user)
    @hash = { user: user }

    make_bootstrap_mail to: user.email
  end
end
