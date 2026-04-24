require "rspec"

RSpec.describe "Applications page" do
  before(:context) do
    post "/register_post", "role" => "mentee", "username" => "mentee", "password" => "Password1","confirm_password" => "Password1", "email_address" => "mentee@email.com"
 
    post "/register_post", "role" => "mentor", "username" => "mentor", "password" => "Password1", "confirm_password" => "Password1", "email_address" => "mentor@email.com"
  end

  describe "GET /view-applications" do
    it "displays the applications page" do

      post "/login-attempt", "username" => "mentor", "password" => "Password1"

      visit "/view-applications"
      expect(page).to have_content("current applications")
    end 
  end
end