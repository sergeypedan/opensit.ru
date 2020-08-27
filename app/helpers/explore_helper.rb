module ExploreHelper
  def posts_visibility
    params[:visibility] || 'all'
  end

  def current_explore_users_page?
    current_page?(explore_users_path) || current_page?(explore_new_users_path) || current_page?(explore_new_sitters_path)
  end
end
