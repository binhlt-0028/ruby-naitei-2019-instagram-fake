class AdminController < ApplicationController
  before_action :current_admin
  def create
    @admin = Admin.new admin_params

    if @admin.save
      redirect_to admin_root_path
    else
      render :new
    end
  end

  private

  def admin_params
    params.permit(:name, :password, :password_confirmation)
  end
end
