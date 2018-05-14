class CreateTaggings < ActiveRecord::Migration[4.2]
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :sit

      t.timestamps
    end
    add_index :taggings, :tag_id
    add_index :taggings, :sit_id
  end
end
