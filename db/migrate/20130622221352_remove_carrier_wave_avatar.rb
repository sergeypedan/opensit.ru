class RemoveCarrierWaveAvatar < ActiveRecord::Migration[4.2]
  def up
  	remove_column :users, :avatar
  end

  def down
  end
end
