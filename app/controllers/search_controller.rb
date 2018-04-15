class SearchController < ApplicationController

	def main
		# @users      = User.fuzzy_search(params[:q]).paginate(page: params[:page])
    @users      = []
		@sits       = Sit.basic_search(params[:q]).communal.paginate(page: params[:page])
		@tagged     = Sit.tagged_with(params[:q]).communal.paginate(page: params[:page]) if Tag.find_by(name: params[:q])
		@page_class = "search-results"
		@title      = "Search: #{params[:q]}"
		render %w[tagged users].include?( params[:type] ) ? params[:type] : "sits"
	end

end
