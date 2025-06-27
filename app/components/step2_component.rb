class Step2Component < ApplicationComponent
  def initialize(registration:)
    @registration = registration
    @business_categories = BusinessCategory.active.order(:sort_order)
  end

  def view_template
    div do
      h3(class: "text-xl font-semibold text-gray-900 mb-6") { "What will your business do?" }
      p(class: "text-gray-600 mb-8") { "Select the option that best describes your main business activity." }

      form_with(
        model: registration,
        url: registration_path(registration, step: 2),
        method: :patch,
        local: true,
        class: "space-y-6"
      ) do |form|
        div(class: "grid grid-cols-1 md:grid-cols-2 gap-4 mb-6") do
          business_categories.each do |category|
            div(
              class: "relative border-2 border-gray-200 rounded-lg p-4 hover:border-indigo-300 cursor-pointer transition-colors",
              data: {
                controller: "category-selector",
                action: "click->category-selector#select"
              }
            ) do
              form.radio_button :business_category_id, category.id,
                class: "absolute top-4 right-4",
                data: { target: "category-selector.radio" }

              div(class: "flex items-start space-x-3") do
                span(class: "text-2xl") { category.icon }
                div do
                  h4(class: "font-semibold text-gray-900") { category.name }
                  p(class: "text-sm text-gray-600 mt-1") { category.description }
                end
              end
            end
          end
        end

        div do
          form.label :custom_business_description, "Tell us a bit more about what your business will do",
            class: "block text-sm font-medium text-gray-700 mb-2"
          form.text_area :custom_business_description,
            placeholder: "I plan to...",
            rows: 4,
            class: "w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
        end

        render ErrorsComponent.new(object: registration, field: :business_category_id) if registration.errors[:business_category_id].any?
        render ErrorsComponent.new(object: registration, field: :custom_business_description) if registration.errors[:custom_business_description].any?

        div(class: "flex justify-between items-center pt-6") do
          link_to "Back",
            step_registration_path(registration, step: 1),
            class: "px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition-colors"

          form.submit "Continue",
            class: "px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors"
        end
      end
    end
  end

  private

  attr_reader :registration, :business_categories
end
