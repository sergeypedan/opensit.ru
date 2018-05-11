module MarkDownHelper

  def markdown(text)
    return "" if text.blank?
    options = [auto_ids: false]
    Kramdown::Document.new(text, *options).to_html.html_safe
  end

end
