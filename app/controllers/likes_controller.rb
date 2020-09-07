class LikesController < ApplicationController
	before_action :authenticate_user!
	before_action :load_sit

	def create
		@user = current_user
		@obj = params[:like][:likeable_type].constantize.find(params[:like][:likeable_id])

		if !@user.likes?(@obj)
	    @likes = @user.likes.new(like_params)
			@likes.save
			@sit ||= Sit.find(params[:like][:likeable_id])
			render 'toggle'
		else
			render :status => 409
		end
	end

	def destroy
    @user = current_user
    @obj = params[:like][:likeable_type].constantize.find(params[:like][:likeable_id])
    @user.unlike!(@obj)
		render 'toggle'
	end

	private

	def like_params
		params.require(:like).permit(:likeable_id, :likeable_type)
	end

	def load_sit
		@sit = Sit.find(params[:like][:likeable_id])
	end
end
