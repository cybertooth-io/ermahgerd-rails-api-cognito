class RemoveJtiFromSessions < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :sessions, :jti }
  end
end
