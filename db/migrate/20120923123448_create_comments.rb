class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :sit_id

      t.timestamps
    end
  end
end
