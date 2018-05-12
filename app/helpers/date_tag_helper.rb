module DateTagHelper

  def date_tag(datetime, format="%-d %B %Y")
    content_tag :time, l(datetime, format: format), datetime: datetime.strftime("%F") if datetime.present?
  end

end
