# frozen_string_literal: true

require 'test_helper'

class InvalidateSessionWorkerTest < ActiveSupport::TestCase
  test 'when invalidating a session it is updated accordingly' do
    session = sessions(:sterling_archer_session)

    assert_changes -> { [session.reload.invalidated_at, session.reload.invalidated_by] } do
      InvalidateSessionWorker.new.perform(
        users(:sterling_archer).id,
        Time.zone.now.iso8601,
        'vvvvvvvv-wwww-xxxx-yyyy-zzzzzzzzzzzz'
      )
    end
  end

  test 'when invalidating a session that cannot be found' do
    session = sessions(:sterling_archer_session)

    assert_no_changes -> { [session.reload.invalidated_at, session.reload.invalidated_by] } do
      InvalidateSessionWorker.new.perform(
        users(:sterling_archer).id,
        Time.zone.now.iso8601,
        'you never get this lalalalalallalla'
      )
    end
  end
end
