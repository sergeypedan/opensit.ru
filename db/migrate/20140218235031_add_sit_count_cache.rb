class AddSitCountCache < ActiveRecord::Migration[4.2]

  def change
    add_column :users, :sits_count, :integer, default: 0

    User.reset_column_information
    User.all.each { |user| User.reset_counters user.id, :sits }
  end

end
