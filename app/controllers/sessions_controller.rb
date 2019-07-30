class SessionsController < ApplicationController
  before_action :load_user, only: :create
  def new; end

  def create
    if @user && @user.authenticate(params[:password])
      if @user.activated?
        log_in @user
        flash[:success] = t "logged_in"
        redirect_to root_path
      else
        flash[:warning] = t("not_activated") + t("check_email")
        redirect_to root_url
      end
    else
      flash.now[:warning] = t "invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = t "logged_out"
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by_email params[:email]
  end
end
