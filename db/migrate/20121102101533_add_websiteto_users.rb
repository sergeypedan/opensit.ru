class AddWebsitetoUsers < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :website, :string, :limit => 100
  end
end
