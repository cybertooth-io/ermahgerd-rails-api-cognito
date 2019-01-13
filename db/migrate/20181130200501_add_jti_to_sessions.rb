class AddJtiToSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :jti, :string, null: false, unique: true
  end
end
