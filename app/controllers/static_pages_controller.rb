class StaticPagesController < ApplicationController
  def home
    if current_user.nil?
      redirect_to login_path
      return
    end
    @posts = current_user.feed.non_block.create_desc
    @post = current_user.posts.build
    @user = current_user
  end
end
