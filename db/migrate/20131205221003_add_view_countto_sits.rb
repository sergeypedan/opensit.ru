class AddViewCounttoSits < ActiveRecord::Migration[4.2]

  def change
  	 add_column :sits, :views, :integer, default: 0
  end

end
