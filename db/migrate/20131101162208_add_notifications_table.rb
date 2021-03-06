class AddNotificationsTable < ActiveRecord::Migration[4.2]
  def change
		create_table(:notifications) do |t|
	    t.integer :user_id
	    t.string :message
	    t.string :link
	    t.integer :initiator
	    t.boolean :viewed, default: false
	    t.timestamps
	  end
  end
end
