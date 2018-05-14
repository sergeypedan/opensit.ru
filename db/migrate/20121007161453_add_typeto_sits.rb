class AddTypetoSits < ActiveRecord::Migration[4.2]
  def change
    add_column :sits, :type, :boolean
  end
end
