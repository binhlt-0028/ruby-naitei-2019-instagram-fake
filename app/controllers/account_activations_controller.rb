class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    token = params[:id]
    if user && !user.activated? && user.activation_token == token
      user.activate
      log_in user
      flash[:success] = t "account_activated"
      redirect_to user
    else
      flash[:danger] = t "invalid_link"
      redirect_to root_url
    end
  end
end
