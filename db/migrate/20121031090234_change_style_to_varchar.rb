class ChangeStyleToVarchar < ActiveRecord::Migration[4.2]
  def change
  	change_column :users, :style, :string, :limit => 100
  end
end
