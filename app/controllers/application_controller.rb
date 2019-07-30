class ApplicationController < ActionController::Base
  before_action :set_locale
  helper_method :current_user, :log_in

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by id: session[:user_id]
    else
      @current_user = nil
    end
  end

  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by id: session[:admin_id]
    else
      @current_admin = nil
    end
    redirect_to admin_login_path unless @current_admin
  end

  def log_in user
    session[:user_id] = user.id
  end
end
