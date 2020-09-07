module CommentsHelper
  def sit_type_for(comment)
    comment.sit.is_meditation? ? 'meditation' : 'diary'
  end

  def link_by(comment)
    link_to(
      comment.sit.is_meditation? ? I18n.t('comments.sit') : comment.sit.full_title,
      "/sits/#{comment.sit_id}/#comment-#{comment.id}"
    )
  end

  def username_by(comment)
    if comment.sit.is_meditation?
      username(comment.sit.user, true)
    end
  end
end
