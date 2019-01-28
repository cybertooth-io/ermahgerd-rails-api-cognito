class AddInCognitoToUsers < ActiveRecord::Migration[5.2]
  def change
    safety_assured { add_column :users, :in_cognito, :boolean, default: false, null: false }
  end
end
