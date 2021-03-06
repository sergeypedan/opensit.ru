class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:welcome, :me, :export]
  before_action :check_date, only: :show

  # GET /welcome
  def welcome
    @user = current_user
    # Prevent /welcome being revisited as GA records each /welcome as a new sign up
    return redirect_to me_path if @user.sign_in_count > 1 || (Time.now - @user.created_at > 10)
    @users_to_follow = User.active_users.limit(3)
  end

  # GET /me page
  def me
    @feed_items = current_user.socialstream.paginate(page: params[:page])
    @user       = current_user
    @latest     = @user.latest_sit(current_user)
    @goals      = @user.goals

    @goals.each do |g|
      if g.completed?
        @has_completed = true
      else
        @has_current = true
      end
    end

    @title = t('menu.home')
    @page_class = 'me'
  end

  # GET /u/buddha
  def show
    @user        = User.where("lower(username) = lower(?)", params[:username]).first!
    @by_month    = @user.journal_range

    month = params[:month] ? params[:month] : Date.today.month
    year  = params[:year]  ? params[:year]  : Date.today.year

    index = @by_month[:list_of_months].index "#{year} #{month}" if @user.sits.present?

    # Generate prev/next links
    # .. for someone who's sat this month
    if index
      @prev = @by_month[:list_of_months][index + 1]&.split(' ')

      if !index.zero?
        @next = @by_month[:list_of_months][index - 1]&.split(' ')
      end
    else
      if @by_month
        # Haven't sat this month - when was the last time they sat?
        @first_month = @by_month[:list_of_months].first&.split(' ')
      end
      # Haven't sat at all
    end

    # Viewing your own profile
    if current_user == @user
      @sits  = @user.sits_by_month(month: month, year: year).newest_first
      @stats = @user.get_monthly_stats(month, year)

    # Viewing someone elses profile
    else
      if !@user.private_stream
        @sits  = @user.sits_by_month(month: month, year: year).communal.newest_first
        @stats = @user.get_monthly_stats(month, year)
      end
    end

    @title = t('user.meditation_journal_title', username: @user.display_name)
    @desc  = t(
      'user.meditation_journal_entries',
      username: @user.display_name,
      sits_count: @user.sits_count,
      brand: ENV.fetch("BRAND")
    )
    @page_class = 'view-user'
  end

  # GET /u/buddha/following
  def following
    @user   = User.where("lower(username) = lower(?)", params[:username]).first!
    @users  = @user.followed_users
    @latest = @user.latest_sit(current_user)
    @title  = user_signed_in? ?
      t("following.followed_users") : t("following.followed_users_for_user", user: @user.display_name)

    @page_class = 'following'
    render :followers
  end

  # GET /u/buddha/followers
  def followers
    @user   = User.where("lower(username) = lower(?)", params[:username]).first!
    @users  = @user.followers
    @latest = @user.latest_sit(current_user)

    @title  = t('following.following_users')
    @title << (@user == current_user ? t('following.me') : @user.display_name)

    @page_class = 'followers'
  end

  # Generate atom feed for user or all public content (global)
  def feed
    if params[:scope] == 'global'
      @sits  = Sit.communal.newest_first.limit(50)
      @title = t('user.global_sit_stream', brand: ENV.fetch("BRAND"))
    else
      @user  = User.where("lower(username) = lower(?)", params[:username]).first!
      @title = t('user.user_sit_stream', username: @user.username)
      @sits  = @user.sits.communal.newest_first.limit(20)
    end

    # This is the feed's update timestamp
    @updated = @sits.last.updated_at unless @sits.empty?

    respond_to do |format|
      format.atom
    end
  end

  # GET /u/buddha/export
  def export
    @user = User.where("lower(username) = lower(?)", params[:username]).first!
    @sits = Sit.where(:user_id => @user.id)

    respond_to do |format|
      format.html
      format.json { render json: @sits.as_json(except: %i[id created_at updated_at]) }
      format.xml { render xml: @sits.as_json(except: %i[id created_at updated_at], skip_types: true) }
    end
  end

  def destroy
    if current_user && current_user.username.in?(User::MODERATOR_USERNAMES)
      @user = User.where("lower(username) = lower(?)", params[:username]).first!

      if @user.destroy
        redirect_to '/explore/users/new', notice: t('user.deleted')
      else
        redirect_to explore_path, notice: t('user.something_wrong')
      end
    end
  end

  private

  # Validate year and month params on user page
  def check_date
    [:year, :month].each do |v|
      if (params[v] && params[v].to_i.zero?) || params[v].to_i > (v == :year ? 3000 : 12)
        unit = v == :year ? 'year' : 'month'
        flash[:error] = "Invalid #{unit}!"
        redirect_to user_path(params[:username])
      end
    end
  end

end
