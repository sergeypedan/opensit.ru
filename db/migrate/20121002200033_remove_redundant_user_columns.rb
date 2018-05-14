# Remove my original password and last_login columns as devise deals with these

class RemoveRedundantUserColumns < ActiveRecord::Migration[4.2]
  def up
    remove_column :users, :password
    remove_column :users, :last_login
  end

  def down
    add_column :users, :password, :string
    add_column :users, :last_login, :datetime
  end
end
