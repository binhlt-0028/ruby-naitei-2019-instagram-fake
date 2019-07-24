class PostsController < ApplicationController
  def create
    @post = current_user.posts.build post_params
    @post.non_block = true
    if @post.save
      flash[:success] = t ".created"
      redirect_to root_url
    else
      flash.now[:danger] = t ".create_fail"
      render "static_pages/home"
    end
  end

  private

  def post_params
    params.require(:post).permit :content, :image
  end
end
