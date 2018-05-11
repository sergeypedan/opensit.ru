class AddDefaultsToSit < ActiveRecord::Migration
  def change
    Sit.where(disable_comments: nil).update_all(disable_comments: false)
    change_column :sits, :disable_comments, :boolean, null: false, default: false
  end
end
