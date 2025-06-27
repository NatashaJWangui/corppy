class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery with: :exception

  before_action :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def require_admin!
    redirect_to root_path unless current_user&.admin?
  end

  def require_compliance_officer!
    redirect_to root_path unless current_user&.can_review_documents?
  end
end
