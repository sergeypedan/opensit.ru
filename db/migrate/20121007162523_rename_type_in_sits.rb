class RenameTypeInSits < ActiveRecord::Migration[4.2]
  def change
    rename_column :sits, :type, :s_type
  end
end
