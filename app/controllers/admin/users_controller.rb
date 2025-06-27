class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_user, only: [ :show, :edit, :update ]

  def index
    @users = User.order(created_at: :desc)

    # Filter by role if provided
    @users = @users.where(role: params[:role]) if params[:role].present?

    # Search by name or email
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
                           search_term, search_term, search_term)
    end
  end

  def show
    @registrations = @user.business_registrations.includes(:business_category, :state).recent
  end

  def edit
    # Allow editing user details and role
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_admin
    unless current_user&.admin?
      flash[:error] = "Access denied."
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :role,
                                 :street_address, :city, :zip_code, :country)
  end
end
