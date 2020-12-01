class PagesController < ApplicationController

  def front
    return redirect_to controller: :users, action: :me if user_signed_in?
    @page_class = 'front-page'
    render "front", layout: "minimal"
  end

  def about
    @title      = t('pages.about')
    @page_class = 'pages-about'
  end

  def about_journal
    @title      = t('pages.about_journal')
    @page_class = 'pages-about_journal'
  end

  def contribute
    @title      = t('pages.contribute')
    @page_class = 'contribute'
  end

  def contact
    @title      = t('pages.contacts.title')
    @page_class = 'contact'
  end

  def explore
    @user = current_user
    @sits = explore_scope_for(@user).newest_first.with_body.limit(20).paginate(page: params[:page])
    @suggested_users = @user.users_to_follow if @user

    @title      = t('pages.explore')
    @page_class = 'explore'
  end

  def calendar
  end

  def tag_cloud
    @title = t('pages.popular_tags')
  end

  def new_users
    @users      = User.newest_users(10).paginate(page: params[:page])
    @page_class = 'new-users'
    @title      = t('pages.newest_users')
    render "users/user_results"
  end

  def online_users
  end

  def new_comments
    @comments = Comment.latest(10).includes(sit: [:user]).paginate(page: params[:page])
    @title    = t('pages.new_comments')
  end

  def users
    @users = User.active_users.limit(10).paginate(page: params[:page])
    @title = t('pages.users')
    render "users/user_results"
  end

  def new_sitters
    @users = User.newest_users(10).where('sits_count > 0').paginate(page: params[:page])
    @title = t('pages.new_sitters')
    render "users/user_results"
  end

  def robots
    env    = Rails.env.production? ? 'production' : 'other'
    robots = File.read("config/robots/robots.#{env}.txt")
    render text: robots, layout: false, content_type: "text/plain"
  end

  private

  def explore_scope_for(user)
    case params[:visibility]
    when 'mine'
      Sit.includes(:user).private_for(@user)
    when 'followed'
      Sit.includes(:user).followed_for(@user)
    when 'popular'
      Sit.includes(:user).most_popular_for(@user)
    else
      Sit.includes(:user).viewable_for(@user)
    end
  end
end
