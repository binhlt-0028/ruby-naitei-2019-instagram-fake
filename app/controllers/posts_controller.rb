class PostsController < ApplicationController
  before_action :load_post, only: %i(show destroy edit update)

  def create
    @post = load_current_user.posts.build post_params
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

  def show
    @current_user = load_current_user
  end

  def edit
    respond_to do |format|
      format.json{render json: @post}
    end
  end

  def update
    flash[:success] = @post.update(post_params) ? t(".updated") : t(".fail")
    redirect_to root_url
  end

  private

  def post_params
    params.require(:post).permit :content, :image
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post
    flash[:danger] = t ".load_error"
    redirect_to root_url
  end
end
