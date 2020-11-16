class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string 'username'
      t.string 'email'
      t.string 'password_digest'
      t.string 'session_token'
      t.timestamps
    end
  end
end
