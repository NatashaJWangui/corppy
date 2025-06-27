# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer_mailer
class RegistrationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/registration_mailer_mailer/document_preview
  def document_preview
    RegistrationMailer.document_preview
  end

  # Preview this email at http://localhost:3000/rails/mailers/registration_mailer_mailer/approval_request
  def approval_request
    RegistrationMailer.approval_request
  end

  # Preview this email at http://localhost:3000/rails/mailers/registration_mailer_mailer/payment_confirmation
  def payment_confirmation
    RegistrationMailer.payment_confirmation
  end

  # Preview this email at http://localhost:3000/rails/mailers/registration_mailer_mailer/document_ready
  def document_ready
    RegistrationMailer.document_ready
  end

  # Preview this email at http://localhost:3000/rails/mailers/registration_mailer_mailer/welcome_email
  def welcome_email
    RegistrationMailer.welcome_email
  end

end
