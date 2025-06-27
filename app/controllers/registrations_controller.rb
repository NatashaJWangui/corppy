# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_registration, except: [ :new, :create ]
  before_action :validate_step_access, only: [ :step ]

  def new
    @registration = current_user.business_registrations.build
    @registration.current_step = 1
  end

  def create
    @registration = current_user.business_registrations.build(registration_params)
    @registration.current_step = 1

    if @registration.save
      redirect_to step_registration_path(@registration, step: 1)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    redirect_to step_registration_path(@registration, step: @registration.current_step)
  end

  def step
    @step = params[:step].to_i
    @business_categories = BusinessCategory.active.order(:sort_order) if @step == 2
    @countries = Country.active if @step == 3
    @states = @registration.country&.states&.active if @step == 3

    case @step
    when 8
      generate_document_if_ready
    end
  end

  def update
    @step = params[:step].to_i

    case @step
    when 1
      update_step_1
    when 2
      update_step_2
    when 3
      update_step_3
    when 4
      update_step_4
    when 5
      update_step_5
    when 6
      update_step_6
    when 7
      update_step_7
    else
      redirect_to_current_step
    end
  end

  private

  def set_registration
    @registration = current_user.business_registrations.find(params[:id])
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def validate_step_access
    @step = params[:step].to_i
    return redirect_to_current_step if @step < 1 || @step > 8
    redirect_to_current_step if @step > @registration.current_step + 1
  end

  def redirect_to_current_step
    redirect_to step_registration_path(@registration, step: @registration.current_step)
  end

  def registration_params
    params.require(:business_registration).permit(:business_name)
  end

  def step_1_params
    params.require(:business_registration).permit(:business_name)
  end

  def step_2_params
    params.require(:business_registration).permit(:business_category_id, :custom_business_description)
  end

  def step_3_params
    params.require(:business_registration).permit(:country_id, :state_id)
  end

  def step_4_params
    params.require(:business_registration).permit(:ownership_type)
  end

  def step_5_params
    params.require(:business_registration).permit(:employee_plans)
  end

  def step_6_params
    params.require(:business_registration).permit(:revenue_expectation, :growth_plans)
  end

  def step_7_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :street_address, :city, :zip_code, :country)
  end

  def update_step_1
    if @registration.update(step_1_params)
      advance_to_next_step
    else
      render_step_with_errors(1)
    end
  end

  def update_step_2
    if @registration.update(step_2_params)
      advance_to_next_step
    else
      @business_categories = BusinessCategory.active.order(:sort_order)
      render_step_with_errors(2)
    end
  end

  def update_step_3
    if @registration.update(step_3_params)
      advance_to_next_step
    else
      @countries = Country.active
      @states = @registration.country&.states&.active
      render_step_with_errors(3)
    end
  end

  def update_step_4
    if @registration.update(step_4_params)
      advance_to_next_step
    else
      render_step_with_errors(4)
    end
  end

  def update_step_5
    if @registration.update(step_5_params)
      advance_to_next_step
    else
      render_step_with_errors(5)
    end
  end

  def update_step_6
    if @registration.update(step_6_params)
      advance_to_next_step
    else
      render_step_with_errors(6)
    end
  end

  def update_step_7
    if current_user.update(step_7_params)
      advance_to_next_step
    else
      @registration.errors.merge!(current_user.errors)
      render_step_with_errors(7)
    end
  end

  def advance_to_next_step
    if @registration.next_step!
      redirect_to step_registration_path(@registration, step: @registration.current_step)
    else
      redirect_to registration_path(@registration)
    end
  end

  def render_step_with_errors(step_number)
    @step = step_number
    render :step, status: :unprocessable_entity
  end

  def generate_document_if_ready
    return unless @registration.ready_for_document_generation?
    return if @registration.current_document&.generated?

    DocumentGenerationJob.perform_later(@registration.id)
    @registration.update(status: :document_generated)
  end
end
