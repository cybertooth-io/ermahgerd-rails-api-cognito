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
        'ca-central-1_vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz',
        '1.2.3.4',
        -60.seconds.from_now.iso8601,
        '/some/path/2/nowhere',
        'somePlatform',
        'somePlatformVersion',
        users(:some_administrator).id,
        'vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz'
      )
    end
  end

  test 'when session already exists, just the activity is created' do
    session = sessions(:sterling_archer_session)

    assert_difference ['SessionActivity.count'] do
      assert_no_difference ['Session.count'] do
        RecordSessionActivityWorker.new.perform(
          'someBrowser',
          'someBrowserVersion',
          -10.seconds.from_now.iso8601,
          'device',
          session.device_key, # already found in sessions.yml
          '1.2.3.4',
          session.authenticated_at.iso8601,
          '/some/path/2/nowhere',
          'somePlatform',
          'somePlatformVersion',
          users(:some_administrator).id,
          'vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz'
        )
      end
    end
  end
end
