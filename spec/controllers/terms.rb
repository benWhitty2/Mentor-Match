require "rspec"

RSpec.describe "Terms and Conditions" do
  context "GET /terms" do
    it "displays it the terms and conditions" do
      get "/terms"
      expect(last_response).to be_ok
      expect(last_response.body).to include "Terms and Conditions"
      expect(last_response.body).to include("<form id = ")
      expect(last_response.body).to include("Accept")
      expect(last_response.body).to include("Decline")
    end
  end
end