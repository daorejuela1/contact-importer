require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/contacts/"
      expect(response).to have_http_status(:redirect)
    end
  end

end
