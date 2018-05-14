class AddDurationToSits < ActiveRecord::Migration[4.2]
  def change
    rename_column :sits, :allow_comments, :disable_comments
    add_column :sits, :duration, :integer
    rename_column :users, :public_diary, :private_diary
    remove_column :users, :profile_pic
  end
end
