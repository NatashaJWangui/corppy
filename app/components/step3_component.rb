class Step3Component < ApplicationComponent
  def initialize(registration:)
    @registration = registration
    @countries = Country.active
    @states = registration.country&.states&.active || State.none
  end

  def view_template
    div do
      h3(class: "text-xl font-semibold text-gray-900 mb-6") { "Where do you want to register your business?" }
      p(class: "text-gray-600 mb-8") { "Select your country and state to see specific requirements and fees." }

      form_with(
        model: registration,
        url: registration_path(registration, step: 3),
        method: :patch,
        local: true,
        class: "space-y-6",
        data: { controller: "location-selector" }
      ) do |form|
        div(class: "grid grid-cols-1 md:grid-cols-2 gap-6") do
          div do
            form.label :country_id, "Country", class: "block text-sm font-medium text-gray-700 mb-2"
            form.select :country_id,
              options_from_collection_for_select(countries, :id, :name, registration.country_id),
              { prompt: "Select a country" },
              {
                class: "w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent",
                data: {
                  action: "change->location-selector#countryChanged",
                  target: "location-selector.country"
                }
              }
          end

          div do
            form.label :state_id, "State", class: "block text-sm font-medium text-gray-700 mb-2"
            form.select :state_id,
              options_from_collection_for_select(states, :id, :name, registration.state_id),
              { prompt: "Select a state" },
              {
                class: "w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent",
                data: { target: "location-selector.state" }
              }
          end
        end

        registration_info if registration.state.present?

        render ErrorsComponent.new(object: registration, field: :country_id) if registration.errors[:country_id].any?
        render ErrorsComponent.new(object: registration, field: :state_id) if registration.errors[:state_id].any?

        div(class: "flex justify-between items-center pt-6") do
          link_to "Back",
            step_registration_path(registration, step: 2),
            class: "px-6 py-3 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition-colors"

          form.submit "Continue",
            class: "px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors"
        end
      end
    end
  end

  private

  attr_reader :registration, :countries, :states

  def registration_info
    return unless registration.document_template

    template = registration.document_template

    div(class: "mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200") do
      h4(class: "font-semibold text-blue-900 mb-2") { "Registration Details for #{registration.state.name}" }

      div(class: "grid grid-cols-1 md:grid-cols-3 gap-4 text-sm") do
        div do
          span(class: "font-medium text-blue-900") { "Filing Fee:" }
          div(class: "text-blue-700") { "$#{template.fees}" }
        end

        div do
          span(class: "font-medium text-blue-900") { "Processing Time:" }
          div(class: "text-blue-700") { template.processing_time }
        end

        div do
          span(class: "font-medium text-blue-900") { "Total Cost:" }
          div(class: "text-blue-700 font-semibold") { registration.formatted_fees }
        end
      end
    end
  end
end
