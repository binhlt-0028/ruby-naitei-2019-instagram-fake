class Admin::PostsController < ApplicationController
  before_action :load_post, except: :index
  before_action :current_admin
  layout "admin_application"

  def index
    @posts = Post.all
  end

  def block
    status = @post.toggle(:non_block) if @post
    @post.save
    status = true if status
    block = @post.non_block? ? "Block" : "Unblock"
    respond_to do |format|
      format.json do
        render json: {status: status, block: block}
      end
    end
  end

  def destroy
    status = @post.destroy if @post
    status = true if status
    respond_to do |format|
      format.json do
        render json: {status: status}
      end
    end
  end

  private

  def load_post
    @post = Post.find_by id: params[:id]
  end
end
