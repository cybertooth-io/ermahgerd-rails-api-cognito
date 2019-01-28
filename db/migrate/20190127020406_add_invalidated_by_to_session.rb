class AddInvalidatedByToSession < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_reference :sessions, :invalidated_by, foreign_key: { :to_table => :users }, null: true, index: false
    add_index :sessions, :invalidated_by_id, algorithm: :concurrently
  end
end
