class AddInvalidatedAtToSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :invalidated_at, :timestamp, null: true
  end
end
