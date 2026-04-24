require "rspec"

RSpec.describe "Home Page" do
  describe "GET /index" do
    it "displays the home page" do
      get "/index"
      expect(last_response).to be_ok
      expect(last_response.body).to include "Home Page"
      expect(last_response.body).to include("<p class = ")
      expect(last_response.body).to include("<form id = ")
    end 
  end
end