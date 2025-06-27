require 'rails_helper'

RSpec.describe "Api::AiAssistants", type: :request do
  describe "GET /chat" do
    it "returns http success" do
      get "/api/ai_assistant/chat"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /response" do
    it "returns http success" do
      get "/api/ai_assistant/response"
      expect(response).to have_http_status(:success)
    end
  end

end
