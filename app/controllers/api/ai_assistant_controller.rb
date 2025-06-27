class Api::AiAssistantController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def chat
    question = params[:question]
    step = params[:step]&.to_i
    registration_id = params[:registration_id]

    if question.blank?
      render json: { error: "Question is required" }, status: :bad_request
      return
    end

    registration = registration_id ? current_user.business_registrations.find_by(id: registration_id) : nil

    # Create interaction record
    interaction = current_user.ai_interactions.create!(
      question: question,
      business_registration: registration,
      step_number: step,
      interaction_type: determine_interaction_type(step, question)
    )

    # Generate AI response immediately (simplified version)
    response = generate_simple_response(question, step, registration)
    interaction.update!(response: response)

    render json: {
      status: "complete",
      interaction_id: interaction.id,
      response: response,
      created_at: interaction.created_at.strftime("%I:%M %p")
    }
  end

  def response
    interaction = current_user.ai_interactions.find(params[:interaction_id])

    render json: {
      status: "complete",
      response: interaction.response,
      created_at: interaction.created_at.strftime("%I:%M %p")
    }
  end

  private

  def authenticate_user!
    head :unauthorized unless current_user
  end

  def determine_interaction_type(step, question)
    case step
    when 1
      "business_name_help"
    when 2
      "business_type_help"
    when 3
      "location_help"
    when 4
      "structure_help"
    when 5
      "goals_help"
    when 6
      "contact_help"
    when 7, 8
      question.downcase.include?("payment") ? "payment_help" : "document_help"
    else
      "general_help"
    end
  end

  def generate_simple_response(question, step, registration)
    # Simple contextual responses based on step
    case step
    when 1
      if question.downcase.include?("name")
        "Great question! Choose a business name that's memorable, easy to spell, and reflects your business. Make sure it's available in your chosen state!"
      else
        "I'm here to help with your business name selection. What specific questions do you have?"
      end
    when 2
      if question.downcase.include?("type") || question.downcase.include?("category")
        "Pick the category that best describes your main business activity. This helps us recommend the right legal structure for your needs!"
      else
        "I can help you choose the right business type. What kind of business are you planning to start?"
      end
    when 3
      if question.downcase.include?("state") || question.downcase.include?("where")
        "Each state has different requirements and costs. Delaware is popular for corporations, while your home state might be simpler. What's your main consideration?"
      else
        "I can help you choose the best state for your business registration. What would you like to know?"
      end
    when 4
      "Business structure affects taxes and legal requirements. Are you planning to have partners or employees? This helps determine the best setup!"
    when 5
      "Your business goals help us recommend the right entity type. Are you planning for steady growth, rapid expansion, or a future sale?"
    when 6
      "Make sure all your contact information is accurate - we'll use this for your official registration documents!"
    when 7
      "Review everything carefully! Once we generate documents, changes require additional processing time and fees."
    when 8
      if question.downcase.include?("payment")
        "We accept credit cards, PayPal, bank transfers, and M-Pesa. All payments are secure and encrypted!"
      else
        "Your documents are being prepared! You'll receive an email to approve, then sign electronically, and finally complete payment."
      end
    else
      "Hi! I'm your Corppy assistant. I can help you with any questions about business registration. What would you like to know?"
    end
  end
end
