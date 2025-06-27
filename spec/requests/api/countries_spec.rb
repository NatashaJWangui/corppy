require 'rails_helper'

RSpec.describe "Api::Countries", type: :request do
  describe "GET /states" do
    it "returns http success" do
      get "/api/countries/states"
      expect(response).to have_http_status(:success)
    end
  end

end
