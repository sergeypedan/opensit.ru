class TagsController < ApplicationController

  def show
    tag_name = params[:id]
    return redirect_to root_path unless Tag.find_by(name: tag_name)
		@sits = Sit.tagged_with tag_name
    @title = "Tag: #{tag_name}"
  end

end
