require "rspec"

RSpec.describe "Withdrawal Request Form" do 
  describe "GET /withdrawal_request" do
    it "displays the withdrawal form" do
      get "/withdrawal_request"
      expect(last_response).to be_ok
      expect(last_response.body).to include "Withdrawal Request"
      expect(last_response.body).to include("<textarea")
      expect(last_response.body).to include("Submit")
    end
  end

  describe "POST /withdrawal_request" do
    context "when no reason is submitted" do
      it "displays an alert" do
        post"/withdrawal_request", "reason" => ""
        expect(last_response).to be_ok
        expect(last_response.body).to include('<script')
        expect(last_response.body).to include('alert(')
      end
    end

    context "when a reason is submitted" do
      it "redirects to the profile page" do
        post "/withdrawal_request", "reason" => "I don't want this mentor anymore"
        expect(last_response).to be_redirect
      end
    end
  end
end