class TagsController < ApplicationController

  def show
    tag_name = params[:id]
    return redirect_to root_path unless Tag.find_by(name: tag_name)
		@sits = Sit.includes(:user).tagged_with tag_name
    @title = t('tags.with_name', tag_name: tag_name)
  end
end
