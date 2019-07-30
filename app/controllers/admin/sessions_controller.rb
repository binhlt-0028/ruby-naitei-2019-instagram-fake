class Admin::SessionsController < ApplicationController
  before_action :load_admin, only: :create

  def new
    render layout: false
  end

  def create
    if @admin && @admin.authenticate(params[:password])
      session[:admin_id] = @admin.id
      flash[:success] = t "logged_in"
      redirect_to admin_root_path
    else
      flash.now[:warning] = t "invalid"
      render :new
    end
  end

  def destroy
    session[:admin_id] = nil
    flash[:success] = t "logged_out"
    redirect_to admin_root_path
  end

  def load_admin
    @admin = Admin.find_by name: params[:name]
  end
end
