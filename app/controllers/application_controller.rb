class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    tank_capacity_chart_fuel_tanks_path
  end

  before_filter { |c| Authorization.current_user = c.current_user }
  def permission_denied
    flash[:danger] = "Sorry, you are not allowed to access that page.";
    redirect_to root_url
  end
end
