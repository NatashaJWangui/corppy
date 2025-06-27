# Preview all emails at http://localhost:3000/rails/mailers/compliance_mailer_mailer
class ComplianceMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/compliance_mailer_mailer/review_assigned
  def review_assigned
    ComplianceMailer.review_assigned
  end

  # Preview this email at http://localhost:3000/rails/mailers/compliance_mailer_mailer/document_approved
  def document_approved
    ComplianceMailer.document_approved
  end

  # Preview this email at http://localhost:3000/rails/mailers/compliance_mailer_mailer/document_rejected
  def document_rejected
    ComplianceMailer.document_rejected
  end

end
