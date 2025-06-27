class Admin::DocumentTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_template, only: [ :show, :edit, :update, :destroy ]

  def index
    @templates = DocumentTemplate.includes(:business_category, :country, :state)
                                .order(:business_category_id, :state_id)

    # Filter by business category or state
    @templates = @templates.where(business_category_id: params[:category_id]) if params[:category_id].present?
    @templates = @templates.where(state_id: params[:state_id]) if params[:state_id].present?
  end

  def show
    # Display template details and preview
  end

  def new
    @template = DocumentTemplate.new
    @business_categories = BusinessCategory.active.order(:sort_order)
    @countries = Country.active
    @states = State.active
  end

  def create
    @template = DocumentTemplate.new(template_params)

    if @template.save
      redirect_to admin_document_template_path(@template),
                  notice: "Document template created successfully."
    else
      @business_categories = BusinessCategory.active.order(:sort_order)
      @countries = Country.active
      @states = State.active
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @business_categories = BusinessCategory.active.order(:sort_order)
    @countries = Country.active
    @states = State.active
  end

  def update
    if @template.update(template_params)
      redirect_to admin_document_template_path(@template),
                  notice: "Document template updated successfully."
    else
      @business_categories = BusinessCategory.active.order(:sort_order)
      @countries = Country.active
      @states = State.active
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_document_templates_path,
                notice: "Document template deleted successfully."
  end

  private

  def set_template
    @template = DocumentTemplate.find(params[:id])
  end

  def ensure_admin
    unless current_user&.admin?
      flash[:error] = "Access denied."
      redirect_to root_path
    end
  end

  def template_params
    params.require(:document_template).permit(:business_category_id, :country_id, :state_id,
                                             :template_name, :template_content, :fees,
                                             :processing_time, :active, :required_fields)
  end
end
