class AddJtiToSessionActivity < ActiveRecord::Migration[5.2]
  def up
    add_column :session_activities, :jti, :string, index: true, null: false
    change_column_default :session_activities, :jti, "FAKE_DEFAULT"
  end

  def down
    remove_column :session_activities, :jti
  end
end
