class AddAccessTokenToSessionActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :session_activities, :access_token, :string, null: false
  end
end
