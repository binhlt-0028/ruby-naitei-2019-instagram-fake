class StaticPagesController < ApplicationController
  def home
    @posts = load_current_user.feed.non_block.create_desc
    @post = load_current_user.posts.build
  end
end
