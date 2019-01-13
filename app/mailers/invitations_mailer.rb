# frozen_string_literal: true

# A mailer used in relation to inviting users to the system.
# TODO: this is not a valid mailer use case and is being used for testing bootstrap mail
class InvitationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitations_mailer.set_password.subject
  #
  def set_password
    @greeting = 'Hi'

    make_bootstrap_mail to: 'to@example.org'
  end
end
