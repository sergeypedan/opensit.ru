class GoalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @goals = @user.goals

    # This isn't nice but it saves having to set up rake tasks
    # We can't just do something like goals.completed because completed? is a
    # dynamically generated Boolean that either reads a db field or manually
    # figures out when a goal is past its due date
    #
    # Maybe just having a global rake task to manually mark the fixed goals as
    # completed when they reach their day is the better solution. This current solution
    # does give goals a nice self-oragnising quality that requires no pruning or checking up.

    @has_completed = @goals.any? { |g| g.completed? }
    @has_current   = @goals.any? { |g| !g.completed? }

    @title = 'My goals'
    @page_class = 'goals'
  end

  def create
    @user              = current_user
    @goal              = @user.goals.new
    @goal.goal_type    = params.dig(:goal, :type) == "ongoing" ? 0 : 1
    @goal.duration     = params.dig(:goal, :duration) if @goal.fixed?
    @goal.mins_per_day = params.dig(:goal, :mins_per_day) if @goal.ongoing?
    @goal.mins_per_day = params.dig(:goal, :mins_per_day_optional) if @goal.fixed?

    if @goal.save
      redirect_to goals_path, notice: t("goals.quotation")
    else
      render :index
    end
  end

  # PUT /goals/1
  def update
    @goal = Goal.find(params[:id])
    @goal.completed_date = Date.today

    if @goal.save!
      redirect_to goals_path, notice: 'Goal marked as completed'
    end
  end

  # DELETE /goals/1
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy

    redirect_to goals_path, notice: 'Goal deleted'
  end
end
