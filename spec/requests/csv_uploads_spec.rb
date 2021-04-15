require 'rails_helper'

RSpec.describe "CsvUploads", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/csv_uploads/new"
      expect(response).to have_http_status(:redirect)
    end
  end

end
