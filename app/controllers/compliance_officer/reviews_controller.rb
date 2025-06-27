class ComplianceOfficer::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_compliance_officer
  before_action :set_review, only: [ :show, :update ]

  def index
    @pending_reviews = ComplianceReview.pending.includes(:document, :business_registration, :reviewer)
    @completed_reviews = ComplianceReview.where(reviewer: current_user).completed.recent.limit(20)
  end

  def show
    @document = @review.document
    @registration = @document.business_registration
  end

  def update
    if @review.update(review_params)
      case @review.status
      when "approved"
        handle_approval
      when "rejected"
        handle_rejection
      end

      redirect_to compliance_officer_reviews_path,
        notice: "Review completed successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_review
    @review = ComplianceReview.find(params[:id])
  end

  def ensure_compliance_officer
    unless current_user&.compliance_officer? || current_user&.admin?
      flash[:error] = "Access denied."
      redirect_to root_path
    end
  end

  def review_params
    params.require(:compliance_review).permit(:status, :notes, :approval_decision)
  end

  def handle_approval
    @review.update!(
      reviewed_at: Time.current,
      approval_decision: "approved"
    )

    @review.document.update!(status: :compliance_approved)
    @review.document.business_registration.update!(status: :completed)

    # Generate final documents and send to user
    RegistrationMailer.document_ready(@review.document.business_registration.id).deliver_later
    ComplianceMailer.document_approved(@review.document.business_registration.id).deliver_later
  end

  def handle_rejection
    @review.update!(
      reviewed_at: Time.current,
      approval_decision: "rejected"
    )

    @review.document.update!(status: :rejected)
    @review.document.business_registration.update!(status: :rejected)

    ComplianceMailer.document_rejected(@review.document.business_registration.id, @review.notes).deliver_later
  end
end
