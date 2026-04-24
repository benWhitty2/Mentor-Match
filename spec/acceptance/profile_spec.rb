require "rspec"

RSpec.describe "Profile" do
  describe "GET /profile" do
    context "when the user is not logged in" do
      it "redirects to the login page" do
        visit "/profile"
        expect(page.current_path).to eq("/login")
      end
    end

    context "when the user is logged in" do

      it "displays the profile page" do
        get "/profile"
        expect(last_response).to be_ok
        expect(last_response.body).to include "Profile"
        expect(last_response.body).to include "Username"  
      end

      context "when user is nil" do
        it "displays a default user" do
          get "/profile", {"@user" => ""}
          expect(last_response).to be_ok
          expect(last_response.body).to include "Username"
          expect(last_response.body).to include ("Username")
        end
      end

      context "when user is not nil" do
        it "displays the logged in user" do
          get "/profile"
          expect(last_response).to be_ok
          expect(last_response.body).to include "Username"
          expect(last_response.body).to include("<%= @user.username %>")
        end
      end

      context "when withdrawal link is clicked" do
        it "redirects to the withdrawal page" do
          visit "/profile"
          click_link "Withdrawal Request"
          expect(last_response).to be_redirect
        end
      end

    end
  end
end