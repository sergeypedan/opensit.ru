module GoalsHelper
  def coloured_rating(goal)
    case goal.rating_colour
    when 'red'
      "<div class='rating rating-red'>#{goal.rating}%</div>".html_safe
    when 'amber'
      "<div class='rating rating-amber'>#{goal.rating}%</div>".html_safe
    when 'green'
      "<div class='rating rating-green'>#{goal.rating}%</div>".html_safe
    when 'gold'
      "<div class='rating rating-gold'>#{goal.rating}%</div>".html_safe
    end
  end

  def days_ago_in_words(from)
  	days = (Date.today - from.to_date).to_i
  	return t('goals.today') if days == 0
  	return t('goals.yesterday') if days == 1
  	return t('goals.days_ago', count: days + 1)
  end

  def start_day_by(goal)
    I18n.l(goal.created_at, format: :goal_date_format)
  end

  def end_day_by(goal)
    I18n.l(goal.completed_date ? goal.completed_date : goal.last_day_of_goal, format: :goal_date_format)
  end
end