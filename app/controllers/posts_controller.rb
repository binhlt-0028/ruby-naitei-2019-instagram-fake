class PostsController < ApplicationController
  before_action :correct_user, only: :destroy

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

  def destroy
    if @post.destroy
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".detete_error"
    end
    redirect_to root_url
  end

  private

  def post_params
    params.require(:post).permit :content, :image
  end

  def correct_user
    @post = load_current_user.posts.find_by id: params[:id]
    redirect_to root_url unless @post
  end
end
