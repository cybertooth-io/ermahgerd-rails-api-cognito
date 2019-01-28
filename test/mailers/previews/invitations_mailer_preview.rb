# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/invitations_mailer
class InvitationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/invitations_mailer/activate_new_account
  def activate_new_account
    InvitationsMailer.activate_new_account(User.new(email: 'some@email.com'), 'someTemporaryP@ssw0rd')
  end

  # Preview this email at http://localhost:3000/rails/mailers/invitations_mailer/set_password
  def set_password
    InvitationsMailer.set_password
  end

  # Preview this email at http://localhost:3000/rails/mailers/invitations_mailer/welcome_existing_user
  def welcome_existing_user
    InvitationsMailer.welcome_existing_user(User.new(email: 'some@email.com'))
  end
end
