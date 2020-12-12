class AddOauthUsernameToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :oauth_username, :string
  end
end
