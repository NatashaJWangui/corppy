class RegistrationWizardComponent < ApplicationComponent
  def initialize(registration:, step:)
    @registration = registration
    @step = step
  end

  def view_template
    div(class: "min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-8") do
      div(class: "max-w-4xl mx-auto px-4") do
        wizard_header
        wizard_progress
        wizard_content
        ai_assistant if show_ai_assistant?
      end
    end
  end

  private

  attr_reader :registration, :step

  def wizard_header
    div(class: "bg-white rounded-lg shadow-sm p-6 mb-6") do
      div(class: "flex items-center justify-between") do
        div do
          link_to "/", class: "flex items-center space-x-2" do
            img(src: "/logo.png", alt: "Corppy", class: "h-8 w-auto")
            span(class: "text-xl font-bold text-gray-900") { "Corppy" }
          end
        end
        div(class: "flex items-center space-x-4") do
          span(class: "text-sm text-gray-600") { "Step #{step} of 8" }
          span(class: "text-sm font-medium text-indigo-600") { registration.step_name }
        end
      end
    end
  end

  def wizard_progress
    div(class: "bg-white rounded-lg shadow-sm p-6 mb-6") do
      div(class: "mb-4") do
        h2(class: "text-2xl font-bold text-gray-900 mb-2") { "Let's start your business" }
        p(class: "text-gray-600") { "Answer a few simple questions and we'll handle the rest" }
      end

      div(class: "relative") do
        div(class: "flex items-center justify-between mb-2") do
          span(class: "text-sm font-medium text-indigo-600") { "Step #{step} of 8" }
          span(class: "text-sm font-medium text-indigo-600") { "#{registration.progress_percentage}%" }
        end

        div(class: "w-full bg-gray-200 rounded-full h-2") do
          div(
            class: "bg-indigo-600 h-2 rounded-full transition-all duration-300",
            style: "width: #{registration.progress_percentage}%"
          )
        end
      end
    end
  end

  def wizard_content
    div(class: "bg-white rounded-lg shadow-sm p-8") do
      case step
      when 1
        render Step1Component.new(registration: registration)
      when 2
        render Step2Component.new(registration: registration)
      when 3
        render Step3Component.new(registration: registration)
      when 4
        render Step4Component.new(registration: registration)
      when 5
        render Step5Component.new(registration: registration)
      when 6
        render Step6Component.new(registration: registration)
      when 7
        render Step7Component.new(registration: registration)
      when 8
        render Step8Component.new(registration: registration)
      end
    end
  end

  def ai_assistant
    div(
      id: "ai-assistant",
      class: "fixed bottom-6 right-6 bg-indigo-600 text-white rounded-lg shadow-lg p-4 max-w-sm",
      data: { controller: "ai-assistant" }
    ) do
      div(class: "flex items-center justify-between mb-3") do
        div(class: "flex items-center space-x-2") do
          span(class: "text-sm font-medium") { "💬 Corppy Assistant" }
        end
        button(
          class: "text-white hover:text-gray-200",
          data: { action: "click->ai-assistant#toggle" }
        ) { "×" }
      end

      div(id: "ai-chat", class: "hidden") do
        div(class: "bg-white text-gray-900 rounded p-3 mb-3 text-sm") do
          "Hi there! I'm your Corppy assistant. Need help with any of these questions? I'm here to guide you through the process."
        end

        div(class: "flex") do
          input(
            type: "text",
            placeholder: "Type your question...",
            class: "flex-1 px-3 py-2 text-sm text-gray-900 rounded-l border-0 focus:ring-0",
            data: { target: "ai-assistant.input" }
          )
          button(
            class: "px-3 py-2 bg-indigo-700 hover:bg-indigo-800 rounded-r",
            data: { action: "click->ai-assistant#send" }
          ) { "⚡" }
        end
      end

      div(class: "text-center") do
        button(
          class: "text-sm hover:text-gray-200",
          data: { action: "click->ai-assistant#toggle" }
        ) { "Hi there! I'm your Corppy assistant." }
      end
    end
  end

  def show_ai_assistant?
    true
  end
end
