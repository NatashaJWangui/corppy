# app/controllers/documents_controller.rb
class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document
  before_action :verify_access

  def show
    respond_to do |format|
      format.html
      format.pdf { send_pdf }
    end
  end

  def approve
    token = params[:token]

    if @document.approve_via_email!(token)
      flash[:success] = "Document approved successfully! You can now proceed with e-signature."
      redirect_to step_registration_path(@document.business_registration, step: 8)
    else
      flash[:error] = "Invalid or expired approval token."
      redirect_to root_path
    end
  end

  def sign
    signature_data = params[:signature_data]
    ip_address = request.remote_ip

    if signature_data.present?
      signature = @document.sign_document!(signature_data, ip_address)

      if signature.persisted?
        render json: {
          status: "success",
          message: "Document signed successfully!",
          redirect_url: step_registration_path(@document.business_registration, step: 8)
        }
      else
        render json: {
          status: "error",
          message: "Failed to save signature. Please try again."
        }
      end
    else
      render json: {
        status: "error",
        message: "No signature data provided."
      }
    end
  end

  def download
    send_pdf
  end

  def email_preview
    @document.create_email_approval!

    render json: {
      status: "success",
      message: "Email sent successfully!"
    }
  end

  def resend_approval
    @document.create_email_approval!

    render json: {
      status: "success",
      message: "Approval email resent!"
    }
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def verify_access
    unless can_access_document?
      flash[:error] = "You don't have permission to access this document."
      redirect_to root_path
    end
  end

  def can_access_document?
    return true if current_user&.admin?
    return true if @document.business_registration.user == current_user
    return true if current_user&.compliance_officer? && @document.paid?

    false
  end

  def send_pdf
    pdf_path = @document.file_path || @document.generate_pdf

    send_file pdf_path,
      filename: "#{@document.business_registration.business_name.parameterize}_incorporation.pdf",
      type: "application/pdf",
      disposition: "inline"
  end
end
