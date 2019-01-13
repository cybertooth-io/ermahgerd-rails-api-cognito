class RemoveUserColumns < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_columns :users, :first_name, :last_name, :nickname }
  end
end
