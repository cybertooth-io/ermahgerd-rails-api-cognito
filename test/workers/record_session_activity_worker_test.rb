# frozen_string_literal: true

require 'test_helper'

class RecordSessionActivityWorkerTest < ActiveSupport::TestCase
  test 'when session & session activity is successfully created' do
    assert_difference ['Session.count', 'SessionActivity.count'] do
      RecordSessionActivityWorker.new.perform(
        'someBrowser',
        'someBrowserVersion',
        -10.seconds.from_now.iso8601,
        'device',
        '1.2.3.4',
        -60.seconds.from_now.iso8601,
        'someJTI',
        '/some/path/2/nowhere',
        'somePlatform',
        'somePlatformVersion',
        users(:some_administrator).id
      )
    end
  end

  test 'when session already exists, just the activity is created' do
    # first create the session
    Session.create!(
      browser: 'someBrowser',
      browser_version: 'someBrowserVersion',
      created_at: -60.seconds.from_now.iso8601,
      device: 'device',
      ip_address: '1.2.3.4',
      jti: 'someJTI',
      platform: 'somePlatform',
      platform_version: 'somePlatformVersion',
      user_id: users(:some_administrator).id
    )

    assert_difference ['SessionActivity.count'] do
      assert_no_difference ['Session.count'] do
        RecordSessionActivityWorker.new.perform(
          'someBrowser',
          'someBrowserVersion',
          -10.seconds.from_now.iso8601,
          'device',
          '1.2.3.4',
          -60.seconds.from_now.iso8601,
          'someJTI',
          '/some/path/2/nowhere',
          'somePlatform',
          'somePlatformVersion',
          users(:some_administrator).id
        )
      end
    end
  end
end
