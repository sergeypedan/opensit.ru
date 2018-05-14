class AddStreakToUsers < ActiveRecord::Migration[4.2]

  def change
  	add_column :users, :streak, :integer, default: 0
  end

end
