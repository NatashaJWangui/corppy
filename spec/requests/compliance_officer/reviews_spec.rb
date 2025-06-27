require 'rails_helper'

RSpec.describe "ComplianceOfficer::Reviews", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/compliance_officer/reviews/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/compliance_officer/reviews/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/compliance_officer/reviews/update"
      expect(response).to have_http_status(:success)
    end
  end

end
