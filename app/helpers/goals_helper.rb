module GoalsHelper
  def coloured_rating(rating)
    "<div class='rating rating-#{rating_colour(rating)}'>#{rating}%</div>".html_safe
  end

  def days_ago_in_words(from)
  	days = (Date.today - from.to_date).to_i
  	return t('goals.today') if days == 0
  	return t('goals.yesterday') if days == 1
  	return t('goals.days_ago', count: days + 1)
  end

  # Gold for 100%, Green for 80% and above, Amber for 50% and above, Red for anything below
  def rating_colour(rating)
    case rating
    when 0..49  then 'red'
    when 50..79 then 'amber'
    when 80..99 then 'green'
    when 100    then 'gold'
    end
  end

  def start_day_by(goal)
    I18n.l(goal.created_at, format: :goal_date_format)
  end

  def end_day_by(goal)
    I18n.l(goal.completed_date ? goal.completed_date : goal.last_day_of_goal, format: :goal_date_format)
  end
end