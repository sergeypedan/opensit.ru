class SearchController < ApplicationController
	helper_method :rendered_template

	def main
		# @users      = User.fuzzy_search(params[:q]).paginate(page: params[:page])
    @users      = []
		@sits       = Sit.basic_search(params[:q]).communal.paginate(page: params[:page])
		@tagged     = Sit.tagged_with(params[:q]).communal.paginate(page: params[:page]) if Tag.find_by(name: params[:q])
		@page_class = "search-results"
		@title      = t('search.title', query: params[:q])

		render rendered_template
	end

	private

	def rendered_template
		return 'sits' if (params[:type] == 'sits') || (params[:type] == 'tagged' && @tagged.blank?)

		params[:type]
	end
end
