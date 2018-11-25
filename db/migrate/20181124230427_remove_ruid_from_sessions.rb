class RemoveRuidFromSessions < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :sessions, :ruid }
  end
end
