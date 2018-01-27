class CommentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  def create
    @sit = Sit.find(params[:sit_id])
    @comment = @sit.comments.build(params[:comment])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Your comment has been added.' }
        format.js
      else
        render action: "new"
      end
    end
  end

  # PUT /comments/1
  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      redirect_to @comment, notice: 'Your comment has been updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.user == current_user
        @comment.destroy
        format.html { redirect_to @comment.sit, notice: 'Your comment has been deleted.' }
        format.js
      else
        format.html { redirect_to @comment.sit, notice: 'You do not have permission to delete this.' }
      end
    end

  end
end
