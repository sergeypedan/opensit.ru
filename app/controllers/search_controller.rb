class SearchController < ApplicationController

	def main
		@users      = User.fuzzy_search(params[:q]).paginate(page: params[:page])
		@sits       = Sit.basic_search(params[:q]).communal.paginate(page: params[:page])
		@tagged     = Sit.tagged_with(params[:q]).communal.paginate(page: params[:page]) if Tag.find_by_name(params[:q]) != nil
		@page_class = "search-results"
		@title      = "Search: #{params[:q]}"
		render %w[tagged users].include?( params[:type] ) ? params[:type] : "sits"
	end

end
