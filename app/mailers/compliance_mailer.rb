class ComplianceMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.compliance_mailer.review_assigned.subject
  #
  def review_assigned
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.compliance_mailer.document_approved.subject
  #
  def document_approved
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.compliance_mailer.document_rejected.subject
  #
  def document_rejected
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
