class PaymentProcessingJob < ApplicationJob
  queue_as :default

  def perform(payment_id)
    payment = Payment.find(payment_id)
    registration = payment.business_registration

    return unless payment.completed?

    # Update registration status
    registration.update!(status: :paid)

    # Send confirmation email
    RegistrationMailer.payment_confirmation(registration.id).deliver_now

    # Create compliance review
    create_compliance_review(registration)

    # Notify compliance team
    ComplianceMailer.review_assigned(registration.id).deliver_now
  end

  private

  def create_compliance_review(registration)
    reviewer = User.compliance_officer.first
    return unless reviewer

    ComplianceReview.create!(
      document: registration.current_document,
      reviewer: reviewer,
      status: :pending,
      notes: "Automatic review created after payment completion"
    )
  end
end
