class Admin::BusinessRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_registration, only: [ :show, :edit, :update ]

  def index
    @registrations = BusinessRegistration.includes(:user, :business_category, :state)
                                        .order(created_at: :desc)
                                        .page(params[:page])

    # Filter by status if provided
    @registrations = @registrations.where(status: params[:status]) if params[:status].present?

    # Search by business name or user email
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @registrations = @registrations.joins(:user)
                                   .where("business_registrations.business_name ILIKE ? OR users.email ILIKE ?",
                                          search_term, search_term)
    end
  end

  def show
    @documents = @registration.documents.includes(:e_signatures, :compliance_reviews)
    @payments = @registration.payments.order(created_at: :desc)
  end

  def edit
    # Allow editing certain fields
  end

  def update
    if @registration.update(registration_params)
      redirect_to admin_business_registration_path(@registration),
                  notice: "Registration updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_registration
    @registration = BusinessRegistration.find(params[:id])
  end

  def ensure_admin
    unless current_user&.admin?
      flash[:error] = "Access denied."
      redirect_to root_path
    end
  end

  def registration_params
    params.require(:business_registration).permit(:status, :business_name, :custom_business_description)
  end
end
