class AddPrivateStreamToUser < ActiveRecord::Migration[4.2]
  def change
  	 add_column :users, :private_stream, :boolean, default: false
  end
end
