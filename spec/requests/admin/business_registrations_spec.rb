require 'rails_helper'

RSpec.describe "Admin::BusinessRegistrations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/business_registrations/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/business_registrations/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/business_registrations/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/business_registrations/update"
      expect(response).to have_http_status(:success)
    end
  end

end
