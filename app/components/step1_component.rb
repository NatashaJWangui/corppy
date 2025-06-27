class Step1Component < ApplicationComponent
  def initialize(registration:)
    @registration = registration
  end

  def view_template
    div do
      h3(class: "text-xl font-semibold text-gray-900 mb-6") { "What would you like to name your business?" }
      p(class: "text-gray-600 mb-8") { "This is what customers will know you by. Don't worry, you can change it later." }

      form_with(
        model: registration,
        url: registration_path(registration, step: 1),
        method: :patch,
        local: true,
        class: "space-y-6"
      ) do |form|
        div do
          form.label :business_name, "Business Name", class: "block text-sm font-medium text-gray-700 mb-2"
          form.text_field :business_name,
            placeholder: "My Amazing Business",
            class: "w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent",
            required: true
        end

        render ErrorsComponent.new(object: registration, field: :business_name) if registration.errors[:business_name].any?

        div(class: "flex justify-between items-center pt-6") do
          div # Empty div for spacing

          form.submit "Continue",
            class: "px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors"
        end
      end
    end
  end

  private

  attr_reader :registration
end
