require 'rails_helper'

RSpec.describe "CsvMappers", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/csv_mapper/new"
      expect(response).to have_http_status(:success)
    end
  end

end
