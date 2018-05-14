class AddGoalsTable < ActiveRecord::Migration[4.2]

  def change
  	create_table(:goals) do |t|
	    t.references :user
	    t.integer :goal_type
			t.integer :duration
			t.integer :mins_per_day
			t.datetime :completed_date
			t.timestamps
	  end
  end

end
