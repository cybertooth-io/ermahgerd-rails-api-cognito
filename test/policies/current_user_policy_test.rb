# frozen_string_literal: true

require 'test_helper'

class CurrentUserPolicyTest < ActiveSupport::TestCase
  test 'when create' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), User).create?
    assert_not CurrentUserPolicy.new(users(:some_guest), User).create?
  end

  test 'when destroy' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), users(:sterling_archer)).destroy?
    assert_not CurrentUserPolicy.new(users(:some_guest), users(:sterling_archer)).destroy?
  end

  test 'when index' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), User).index?
    assert_not CurrentUserPolicy.new(users(:some_guest), User).index?
  end

  test 'when show' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), users(:sterling_archer)).show?
    assert_not CurrentUserPolicy.new(users(:some_guest), users(:sterling_archer)).show?
  end

  test 'when showing me' do
    assert CurrentUserPolicy.new(users(:some_guest), users(:some_guest)).show?
  end

  test 'when sign out' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), users(:sterling_archer)).sign_out?
    assert_not CurrentUserPolicy.new(users(:some_guest), users(:sterling_archer)).sign_out?
  end

  test 'when signing me out' do
    assert CurrentUserPolicy.new(users(:some_guest), users(:some_guest)).sign_out?
  end

  test 'when update' do
    assert_not CurrentUserPolicy.new(users(:some_administrator), users(:sterling_archer)).update?
    assert_not CurrentUserPolicy.new(users(:some_guest), users(:sterling_archer)).update?
  end

  test 'when updating my user record' do
    assert_not CurrentUserPolicy.new(users(:some_guest), users(:some_guest)).update?
  end
end
