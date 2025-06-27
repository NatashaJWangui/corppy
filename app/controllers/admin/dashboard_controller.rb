class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @total_registrations = BusinessRegistration.count
    @pending_reviews = ComplianceReview.pending.count
    @completed_today = BusinessRegistration.where(status: :completed, updated_at: Date.current.all_day).count
    @total_users = User.count
    @revenue_this_month = calculate_monthly_revenue
    @recent_registrations = BusinessRegistration.includes(:user, :business_category, :state).recent.limit(10)
  end

  private

  def ensure_admin
    unless current_user&.admin?
      flash[:error] = "Access denied. Admin privileges required."
      redirect_to root_path
    end
  end

  def calculate_monthly_revenue
    Payment.where(status: :completed, paid_at: Date.current.beginning_of_month..Date.current.end_of_month)
           .sum(:amount)
  end
end
