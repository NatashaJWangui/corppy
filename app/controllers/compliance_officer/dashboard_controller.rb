class ComplianceOfficer::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_compliance_officer

  def index
    @pending_reviews = ComplianceReview.pending.includes(:document, :reviewer)
    @completed_today = ComplianceReview.where(reviewer: current_user, reviewed_at: Date.current.all_day)
    @total_reviews = ComplianceReview.where(reviewer: current_user).count
    @pending_count = @pending_reviews.count
  end

  private

  def ensure_compliance_officer
    unless current_user&.compliance_officer? || current_user&.admin?
      flash[:error] = "Access denied. Compliance officer privileges required."
      redirect_to root_path
    end
  end
end
