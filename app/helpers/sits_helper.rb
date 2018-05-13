module SitsHelper

	def teaser(sit, length = 300, search = nil)
		stripped = strip_tags(sit.custom_strip)
		return truncate(stripped, length: length, omission: " ...") unless search
		excerpt = excerpt(stripped, search, radius: 200)
		return highlight(excerpt, search) if excerpt.present?
		return truncate(stripped, length: length, omission: " ...") if excerpt.blank?
	end

	def teaser_title(sit, type = false)
		if sit.is_meditation?
      " sat for <a class='sit-link' title='#{sit.duration} minute meditation report by #{sit.user.display_name}' href='#{sit_path(sit)}'>#{sit.duration} minutes</a>".html_safe
		else
			"added a <a class='sit-link' title='#{sit.title} by #{sit.user.display_name}' href='#{sit_path(sit)}'>diary</a>.".html_safe
		end
	end

	def display_lock_if_private(sit)
		return unless sit.private
		'<div class="private-event pull-right" title="This is a private entry. Only you can see it."><i class="fa fa-lock"></i></div>'.html_safe
	end

	def liked_names(sit)
		return "" if (current_user != sit.user) && sit.likers.empty?
		return (sit.likers.map { |user| user.display_name } * ', ')
	end

	def like_button_text(sit)
		return 'Like it?' if (current_user != sit.user) && sit.likers.empty?
		people  = pluralize(sit.likes.count, 'person')
		do_like = sit.likes.count == 1 ? "likes" : "like"
		"#{people} #{do_like} this"
	end

end
