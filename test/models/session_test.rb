# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'when fetching the last session activity' do
    assert_equal(
      session_activities(:sterling_archer_session_activity).access_token,
      sessions(:sterling_archer_session).last_session_activity.access_token
    )
  end

  test 'when filtering by validated' do
    assert_equal 0, Session.by_invalidated.count
    sessions(:sterling_archer_session).update! invalidated_at: Time.zone.now
    assert_equal 1, Session.by_invalidated.count
  end

  test 'when filtering by active' do
    assert_equal 1, Session.by_active.count
    sessions(:sterling_archer_session).update! invalidated_at: Time.zone.now
    assert_equal 0, Session.by_active.count
  end

  test 'when adding a session that already exists' do
    sterling_archer_session = sessions(:sterling_archer_session)

    session = Session.new(
      authenticated_at: sterling_archer_session.authenticated_at,
      browser: 'Internet Exploder',
      browser_version: 6,
      device: 'Unknown',
      device_key: sterling_archer_session.device_key,
      invalidated_at: nil,
      invalidated_by: nil,
      ip_address: '1.2.3.4',
      platform: 'Windows XP',
      platform_version: '5.1.2600',
      user: users(:some_guest)
    )

    assert_not session.valid?
  end

  test 'when adding a session that does not already exist' do
    sterling_archer_session = sessions(:sterling_archer_session)

    session = Session.new(
      authenticated_at: sterling_archer_session.authenticated_at,
      browser: 'Internet Exploder',
      browser_version: 6,
      device: 'Unknown',
      device_key: 'uu-region-#_vvvvvvvv-wwww-xxxx-yyyy-012345678901',
      expires_at: sterling_archer_session.expires_at,
      invalidated_at: nil,
      invalidated_by: nil,
      ip_address: '1.2.3.4',
      platform: 'Windows XP',
      platform_version: '5.1.2600',
      user: users(:some_guest)
    )

    assert session.valid?
  end

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
