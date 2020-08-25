class AddVisibilityToSit < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE sit_visibility AS ENUM ('private', 'followers', 'groups', 'public');
    SQL
    add_column :sits, :visibility, :sit_visibility, default: 'public'
    add_index :sits, :visibility

    Sit.where(private: true).update_all(visibility: 'private')

    remove_column :sits, :private
  end

  def down
    add_column :sits, :private, :boolean, default: false

    Sit.where(visibility: 'private').update_all(private: true)

    remove_index :sits, :visibility
    remove_column :sits, :visibility
    execute <<-SQL
      DROP TYPE sit_visibility;
    SQL
  end
end
