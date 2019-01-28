# frozen_string_literal: true

require 'test_helper'

class SessionActivityTest < ActiveSupport::TestCase
  test 'when filtering by jti' do
    assert_equal 0, SessionActivity.by_jti(nil).count
    assert_equal 0, SessionActivity.by_jti('').count
    assert_equal 1, SessionActivity.by_jti('vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz').count
  end
end
