require 'rails_helper'

RSpec.describe "Api::PaymentWebhooks", type: :request do
  describe "GET /mpesa" do
    it "returns http success" do
      get "/api/payment_webhooks/mpesa"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /stripe" do
    it "returns http success" do
      get "/api/payment_webhooks/stripe"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /paypal" do
    it "returns http success" do
      get "/api/payment_webhooks/paypal"
      expect(response).to have_http_status(:success)
    end
  end

end
