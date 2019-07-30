class FollowUsersController < ApplicationController
  def create
    # current_user.active_relationships.build followed_id: params[:followed_id]
    @user = User.find_by id: params[:followed_id]
    status = current_user.follow(@user) ? 200 : 404
    count = @user.followers.count
    respond_to do |format|
      format.json do
        render json: {status: status, data: count}
      end
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    status = current_user.unfollow(@user) ? 200 : 404
    count = @user.followers.count
    respond_to do |format|
      format.json do
        render json: {status: status, data: count}
      end
    end
  end
end
