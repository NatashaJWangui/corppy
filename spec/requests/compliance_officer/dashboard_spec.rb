require 'rails_helper'

RSpec.describe "ComplianceOfficer::Dashboards", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/compliance_officer/dashboard/index"
      expect(response).to have_http_status(:success)
    end
  end

end
