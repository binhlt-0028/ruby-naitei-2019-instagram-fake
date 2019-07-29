class CommentsController < ApplicationController
  before_action :correct_comment, only: %i(destroy update edit)

  def create
    @comment = load_current_user.comments.build
    @comment.post_id = params[:post_id]
    @comment.content = params[:content]
    @status = @comment.save ? 200 : 404
    @data = return_data @comment
    respond_to do |format|
      format.json{render json: {status: @status, data: @data}}
    end
  end

  def edit
    respond_to do |format|
      format.json{render json: @comment}
    end
  end

  def update
    @status = @comment.update(content: params[:content]) ? 200 : 404
    @data = {
      content: @comment.content,
      count: @comment.post.comments.count,
      username: @comment.user.name,
      user_id: @comment.user.id,
      id: @comment.id
    }
    respond_to do |format|
      format.json{render json: {status: @status, data: @data}}
    end
  end

  def destroy
    @status = @comment.destroy ? 200 : 404
    @count = @comment.post.comments.count
    respond_to do |format|
      format.json do
        render json: {status: @status, data: @count}
      end
    end
  end

  private

  def correct_comment
    @comment = Comment.find_by id: params[:id]
    redirect_to root_url unless @comment
  end

  def return_data comment
    @data = {
      content: comment.content,
      count: comment.post.comments.count,
      username: comment.user.name,
      user_id: comment.user.id,
      id: comment.id
    }
  end
end
