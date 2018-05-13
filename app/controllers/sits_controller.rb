class SitsController < ApplicationController

  before_action :authenticate_user!, except: :show

  # GET /sits/1
  def show
    @sit = Sit.find(params[:id])
    @latest = @sit.user.latest_sit(current_user)

    if @sit.private
      return redirect_to root_path, status: :unauthorized, alert: "This record is private" unless current_user
      return redirect_to me_path if @sit.user_id != current_user.id
    end

    @sit.increment!(:views, by = 1) if current_user&.id != @sit.user_id
    @user = @sit.user

    @title = if @sit.is_meditation?
                "#{@sit.duration} minute meditation journal by #{@user.display_name}"
              else
                "#{@sit.title}, a meditation journal by #{@user.display_name}"
              end

    @previous = @sit.prev(current_user)
    @next = @sit.next(current_user)
  end

  # GET /sits/new
  def new
    @sit = Sit.new(s_type: "meditation", created_at: DateTime.now)
    @user = current_user
    @title = t("sit.new")
    render :edit
  end

  # GET /sits/1/edit
  def edit
    @sit = Sit.find(params[:id])

    if current_user == @sit.user
      @user = current_user
      @title = t("edit.new")
    else
      redirect_to root_path, notice: "You can't edit this post"
    end
  end

  # POST /sits
  def create
    @user = current_user
    @sit = Sit.new filtered_params
    @sit.user = @user
    @sit.private = @user.private_stream
    @sit.created_at = ::InputParsers::Datetime.call params[:custom_date]
    @sit.tags = Tag.parse_CSV params[:tag_list]

    if @sit.save
      redirect_path = @sit.body.present? ? @sit : user_path(@user, year: Date.today.year, month: Date.today.month)
      redirect_to redirect_path, notice: t("new_sit.created_notice")
    else
      @page_class = 'sits-new'
      render :edit
    end
  end

  # PUT /sits/1
  def update
    @sit = Sit.find(params[:id])
    return redirect_to root_path, status: :unauthorized, alert: "You can't edit this post" unless current_user == @sit.user

    @sit.created_at = ::InputParsers::Datetime.call params[:custom_date]
    @sit.tags = Tag.parse_CSV params[:tag_list]

    if @sit.update_attributes(filtered_params)
      redirect_to @sit, notice: 'Sit was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sits/1
  def destroy
    @sit = Sit.find(params[:id])

    if current_user == @sit.user
      @sit.destroy
      redirect_to me_path
    else
      redirect_to root_path, status: :unauthorized, alert: "You can't delete this post"
    end
  end

  private

  def filtered_params
    params.require(:sit).permit(
      :body,
      :created_at,
      :disable_comments,
      :duration,
      :private,
      :s_type,
      :title,
      :user_id,
      :views
    )
  end

end
