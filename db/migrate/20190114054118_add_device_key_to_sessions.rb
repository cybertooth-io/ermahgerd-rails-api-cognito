class AddDeviceKeyToSessions < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_column :sessions, :authenticated_at, :timestamp, null: false
    add_column :sessions, :device_key, :string, null: false
    add_index :sessions, [:authenticated_at, :device_key], unique: true, algorithm: :concurrently
  end
end
