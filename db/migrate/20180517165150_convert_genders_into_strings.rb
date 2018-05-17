class ConvertGendersIntoStrings < ActiveRecord::Migration[5.2]
  def change
    User.update_all(gender: nil)
    change_column :users, :gender, :string
  end
end
