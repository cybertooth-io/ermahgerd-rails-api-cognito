class RemoveSessionColumns < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_columns :sessions, :expiring_at, :invalidated, :invalidated_by_id }
  end
end
