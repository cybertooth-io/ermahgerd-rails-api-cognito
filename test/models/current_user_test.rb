# frozen_string_literal: true

require 'test_helper'

class CurrentUserTest < ActiveSupport::TestCase
  test 'when find by email' do
    assert_equal users(:some_administrator).id, CurrentUser.find_by(email: 'admin@pundit.com').id
  end

  test 'when updating the current user' do
    assert CurrentUser.find_by(id: users(:some_administrator).id).update(email: 'newEmail@eat.it')
  end
end
