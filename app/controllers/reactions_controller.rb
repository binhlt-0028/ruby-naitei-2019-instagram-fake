class ReactionsController < ApplicationController
  before_action :correct_reaction, only: %i(destroy update)

  def create
    @reaction = load_current_user.reactions.build
    @reaction.post = Post.find_by id: params[:post_id]
    @reaction.type_id = Reaction.type_id_enums[params[:type_id]]
    @status = @reaction.save ? 200 : 404
    @count = @reaction.post.reactions.count
    respond_to do |format|
      format.json do
        render json: {status: @status, data: {count: @count, id: @reaction.id}}
      end
    end
  end

  def update
    @type_id = Reaction.type_id_enums[params[:type_id]]
    @status = @reaction.update(type_id: @type_id) ? 200 : 404
    @count = @reaction.post.reactions.count
    respond_to do |format|
      format.json do
        render json: {status: @status, data: {count: @count, id: @reaction.id}}
      end
    end
  end

  def destroy
    @status = @reaction.destroy ? 200 : 404
    @count = @reaction.post.reactions.count
    respond_to do |format|
      format.json do
        render json: {status: @status, data: {count: @count, id: @reaction.id}}
      end
    end
  end

  private

  def correct_reaction
    @reaction = Reaction.find_by id: params[:id]
    redirect_to root_url unless @reaction
  end
end
