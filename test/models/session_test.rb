# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'when filtering by distinct' do
    assert_equal Session.all.count, Session.all.by_distinct.count
  end

  test 'when filtering by jti' do
    assert_equal 0, Session.by_jti(nil).count
    assert_equal 0, Session.by_jti('').count
    assert_equal 1, Session.by_jti('vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz').count
  end

  test 'when filtering by user' do
    assert_equal 0, Session.by_user(nil).count
    assert_equal 0, Session.by_user('').count
    assert_equal 1, Session.by_user(users(:sterling_archer)).count
    assert_equal 1, Session.by_user(users(:sterling_archer).id).count
  end
end
