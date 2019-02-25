class AddExpiresAtToSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :expires_at, :timestamp, null: false
  end
end
