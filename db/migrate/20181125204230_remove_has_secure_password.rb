class RemoveHasSecurePassword < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :users, :password_digest }
  end
end
