class Goal < ActiveRecord::Base

	belongs_to :user

	validates :goal_type, presence: true
	validates :user_id, presence: true, numericality: { only_integer: true }
	validates :duration, presence: true, if: Proc.new { |record| record.goal_type == 1 }
	validates :mins_per_day, presence: true, if: Proc.new { |record| record.goal_type == 0 }

	attr_accessor :mins_per_day_optional

	def verbalise
		text = "#{I18n.t('goals.sit_start')} "
		if ongoing?
			text << I18n.t('goals.ongoing_minutes_per_day', count: mins_per_day)
		else
			if fixed?
				duration_str = I18n.t('units_of_time.days', count: duration)
				if mins_per_day
					text << I18n.t(
						'goals.min_per_days',
						min_per_days: I18n.t('units_of_time.minutes', count: mins_per_day),
						duration: I18n.t('goals.days_in_row', duration: duration_str)
					)
				else
					text << I18n.t('goals.days_in_row', duration: duration_str)
				end
			end
		end
	end

	# Fixed goal e.g. sit for 30 days in a row
	def fixed?
		goal_type == 1
	end

	# Ongoing goal e.g. sit for 30 minutes a day
	def ongoing?
		goal_type == 0
	end

	# Returns how many days into the goal the user is
	def days_into_goal
		end_date = if !!completed_date
								 completed_date
							 elsif fixed?
								 Date.today > last_day_of_goal ? last_day_of_goal : Date.today
							 else
								 Date.today
							 end
		(created_at.to_date .. end_date).count
	end

	# Returns the number of days (since the day the goal began) where the goal was met
	def days_where_goal_met
		# Rate based on last 2 weeks of results, or since started (if less than two weeks into goal)
		start_from = days_into_goal < 14 ? created_at.to_date : Date.today - 13
		end_date = completed? ? (fixed? ? last_day_of_goal : completed_date) : Date.today
		if !fixed? || mins_per_day
			user.days_sat_for_min_x_minutes_in_date_range(mins_per_day, start_from, end_date)
		else
			user.days_sat_in_date_range(created_at.to_date, end_date)
		end
	end

	# How well is the user meeting the goal?
	def rating
		days_to_goal = days_into_goal
		days_to_goal_meet = days_where_goal_met

		if fixed?
			days_to_goal > 0 ? ((days_to_goal_meet.to_f / days_to_goal.to_f) * 100).round : 0
		else
			# Rate based on last 2 weeks of results, or since started (if less than two weeks into goal)
			last_2_weeks = days_to_goal < 14 ? days_to_goal : 14
			last_2_weeks > 0 ? ((days_to_goal_meet.to_f / last_2_weeks.to_f) * 100).round : 0
		end
	end

	# Gold for 100%, Green for 80% and above, Amber for 50% and above, Red for anything below
	def rating_colour
		case rating
		when 0..49  then "red"
		when 50..79 then "amber"
		when 80..99 then "green"
		when 100    then "gold"
		end
	end

	def last_day_of_goal
		created_at.to_date + duration.days - 1 # Minus cos the day the goal was started is the first day
	end

	def completed?
		return true if completed_date # completed_date is used to retire (not delete) a goal
		return true if fixed? && (Date.today > last_day_of_goal) # Fixed goal are auto-marked as complete (not deleted) when past their finish date
		return false
	end

end

# == Schema Information
#
# Table name: goals
#
#  id             :integer          not null, primary key
#  completed_date :datetime
#  duration       :integer
#  goal_type      :integer
#  mins_per_day   :integer
#  user_id        :integer
#
