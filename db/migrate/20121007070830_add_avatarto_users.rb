class AddAvatartoUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :avatar, :string
  end

  def down
    remove_column :users, :avatar
  end
end
