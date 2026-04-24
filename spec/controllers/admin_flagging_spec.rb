RSpec.describe "Admin Flagging" do
  describe "GET /admin_flagging" do
    context "when a non-admin tries to access" do
      it "redirects to index page" do
        get "/admin_flagging"
        expect(last_response).to be_redirect
      end
    end
  end
end