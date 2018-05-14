class CreateLikeTable < ActiveRecord::Migration[4.2]

  create_table :likes do |t|
    t.references :likeable, polymorphic: true
    t.references :user
  end

end
