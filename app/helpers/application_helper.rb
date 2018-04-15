module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title)
    if page_title.nil?
      "#{Rails.application.secrets.brand} | #{t('home.banner.title')}"
    else
      "#{page_title} | #{Rails.application.secrets.brand}, #{t('home.banner.title')}"
    end
  end

  def meta_desc(desc)
    base_desc = "OpenSit is a beautiful, free meditation journal, and place to share and deepen your meditation practice. Join other mindfulness, Vipassana, or Zen Buddhist practitioners!"
    return base_desc if desc.nil?
    return desc
  end

	def tag_cloud(tags, classes)
	  max = tags.sort_by(&:count).last
	  tags.each do |tag|
	    index = tag.count.to_f / max.count.to_f * (classes.size - 1)
	    yield(tag, classes[index.round])
	  end
	end

  def tag_labels(tags)
    raw tags.map { |t| link_to t.name, tag_path(t.name), class: 'label label-default tag-label' }.join
  end

  def form_element(f, field, model, label, input_width,  options = {})
    form =  "<div class='form-group'>"
    form <<   "<label class='col-lg-2 control-label' for='#{model}_#{field}'>"
    form <<     label
    form <<   "</label>"
    form <<   "<div class='col-lg-#{input_width}'>"
    form <<     f.input(field, options)
    form <<   "</div>"
    form << "</div>"
    return form.html_safe
  end

end
