require 'rails_helper'

RSpec.describe "Documents", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/documents/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /approve" do
    it "returns http success" do
      get "/documents/approve"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /sign" do
    it "returns http success" do
      get "/documents/sign"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /download" do
    it "returns http success" do
      get "/documents/download"
      expect(response).to have_http_status(:success)
    end
  end

end
