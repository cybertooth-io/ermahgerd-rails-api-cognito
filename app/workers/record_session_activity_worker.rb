# frozen_string_literal: true

# A Sidekiq Worker that will create a `SessionActivity` record.
class RecordSessionActivityWorker
  include Sidekiq::Worker

  def perform(browser, browser_version, created_at_iso8601, device, ip_address, issued_at_iso8601, jti, path, platform,
              platform_version, user_id)
    session = Session.find_by(jti: jti)

    ActiveRecord::Base.transaction do
      if session.nil?
        session = Session.create!(
          browser: browser,
          browser_version: browser_version,
          created_at: Time.zone.parse(issued_at_iso8601),
          device: device,
          ip_address: ip_address,
          jti: jti,
          platform: platform,
          platform_version: platform_version,
          updated_at: Time.zone.parse(issued_at_iso8601),
          user_id: user_id
        )
      end

      SessionActivity.create!(
        created_at: Time.zone.parse(created_at_iso8601),
        ip_address: ip_address,
        path: path,
        session_id: session.id
      )
    end
  end
end
