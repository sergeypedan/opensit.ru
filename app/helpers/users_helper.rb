module UsersHelper

  MONTHNAMES = %w[january february march april may june july august september october november december]

  def avatar_image(user)
    user.avatar.blank? ? image_path('placeholders/user-1.svg') : user.avatar.url(:small_thumb)
  end

  def small_avatar_of(user, location = nil)
    image_path = avatar_image(user)
    return image_tag image_path if location == 'nav'
    return link_to image_tag(image_path, class: 'img-circle'), user_path(user)
  end

  def large_avatar_of(user)
    return image_tag image_path('placeholders/user-1.svg'), alt: user.username, class: 'img-circle', itemprop: 'image' if user.avatar.blank?
    return link_to image_tag(user.avatar.url(:thumb), size: "250x250", alt: user.username, class: 'img-circle', itemprop: 'image'), user_path(user)
  end

  def sign_up_avatar(user)
    image_tag user.avatar.url(:thumb), size: "70x70", alt: user.username, class: 'img-circle'
  end

  # Return a hyperlinked username / name
  # Pass plain for an unlinked name
  def username(user, plain = false)
    return user.display_name if plain == true
    return link_to user.display_name, user_path(user.username)
  end

  # Return link to website
  def website(user)
    href = (user.website =~ /^(http|https):\/\//) ? user.website : "http://#{user.website}"
    return link_to href, href, rel: :nofollow, target: "_blank"
  end

  def timeline_select_options(dates)
    current_year = Time.now.year

    dates.map do |year_or_month, count|
      if year_or_month.to_s.size == 4
        current_year = year_or_month
        # content_tag :optgroup, label: "#{year_or_month} (#{count})"
        "<optgroup label='#{year_or_month} (#{count})'>"
      else
        selected = (current_year == params[:year].to_i && year_or_month == params[:month].to_i)
        # value    = "#{user_path(params[:username])}/#{params[:id]}?year=#{current_year}&month=#{year_or_month.to_s.rjust(2, '0')}"
        value = user_path(params[:username], year: current_year, month: year_or_month.to_s.rjust(2, '0'))
        content  = "#{I18n.t("month.#{MONTHNAMES[year_or_month - 1]}")}, #{current_year}"
        content_tag :option, content, value: value, selected: selected
      end
    end.join(' ').html_safe
  end

  def joined_date(user)
    if Date.today.month == user.created_at.month
      user.created_at.strftime("%d %b")
    else
      "#{time_ago_in_words(user.created_at)} #{t('ago')}"
    end
  end

  def show_social_buttons_for?(user)
    current_user.present? && (current_user&.id == @user&.id)
  end
end
