# frozen_string_literal: true

# A Sidekiq Worker that will create a `SessionActivity` record.
class RecordSessionActivityWorker
  include Sidekiq::Worker

  def perform(browser, browser_version, created_at_iso8601, device, device_key, ip_address, auth_time_iso8601,
              path, platform, platform_version, user_id, jti)
    authenticated_at = Time.zone.parse(auth_time_iso8601)
    session = Session.find_by(authenticated_at: authenticated_at, device_key: device_key)

    ActiveRecord::Base.transaction do
      if session.nil?
        session = Session.create!(
          authenticated_at: authenticated_at,
          browser: browser,
          browser_version: browser_version,
          device: device,
          device_key: device_key,
          ip_address: ip_address,
          platform: platform,
          platform_version: platform_version,
          user_id: user_id
        )
      end

      SessionActivity.create!(
        created_at: Time.zone.parse(created_at_iso8601),
        ip_address: ip_address,
        jti: jti,
        path: path,
        session_id: session.id
      )
    end
  end
end
