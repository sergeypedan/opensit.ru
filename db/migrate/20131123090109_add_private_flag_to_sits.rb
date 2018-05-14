class AddPrivateFlagToSits < ActiveRecord::Migration[4.2]
  def change
    add_column :sits, :private, :boolean, default: false
  end
end
