class ConvertSitTypeIntoString < ActiveRecord::Migration[4.2]

  def self.up
    Sit.update_all(s_type: nil)
    change_column :sits, :s_type, :string, default: "meditation", null: false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end

end
