# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'when valid on create' do
    user = User.new email: 'some@email.com'
    assert user.valid?
  end

  test 'when not valid on create without email' do
    user = User.new
    assert_not user.valid?
  end

  test 'when using the scope by id' do
    assert_equal 1, User.by_id(users(:sterling_archer).id).count
    assert_equal 2, User.by_id([users(:mallory_archer).id, users(:sterling_archer).id]).count
  end

  test 'when a user has a session that user cannot be deleted' do
    sterling_archer = users(:sterling_archer)
    sterling_archer.destroy

    assert_equal ['Cannot delete record because dependent sessions exist'], sterling_archer.errors.full_messages
  end

  test 'when a user is destroyed their roles are also destroyed' do
    guest_role = roles(:guest)

    assert_equal 3, guest_role.users.count
    assert_difference ['User.count', 'guest_role.users.count'], -1 do
      users(:mallory_archer).destroy!
    end
  end
end
