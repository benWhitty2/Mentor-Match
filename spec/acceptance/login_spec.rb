require "rspec"

RSpec.describe "Login Page" do
  context "given the current page is /login" do
    it "shows the login page" do
      visit "/login"
      expect(page).to have_content("Username:")
      expect(page).to have_content("Password:")
      expect(page).to have_link("forgot password")
    end
  end

  context "given the forgot password is clicked" do
    it "redirects to reset-pass" do
      visit "/login"
      click_on "forgot password"
      expect(page).to have_content("request a password reset")
    end
  end

  context "given that nothing is filled in " do
    it "gives an error message" do
      visit "/login"
      click_on "submit"
      expect(page).to have_content("incorrect")
    end
  end

  context "given a user has been registered " do
    context "when that user attempts to log in " do
      it "logs them in " do
        visit "/register"
        select "Mentee", from: "role"
        fill_in "username", with: "MenteeTest2"
        fill_in "password", with: "TestPassword123"
        fill_in "confirm_password", with: "TestPassword123"
        fill_in "email_address", with: "TestEmail@sheffield.ac.uk"
        check "terms_conditions"
        click_on "Create account"

        visit "/login"
        fill_in "username", with: "MenteeTest2"
        fill_in "password", with: "TestPassword123"
        click_on "Submit"

        expect(page).to have_content("About The Site")
      end
    end
  end
end

# RSpec.describe "Login page" do
#   #before(:context) do
#   #  post "/register_post", "role" => "mentee", "username" => "mentee", "password" => "Password1","confirm_password" => "Password1", "email_address" => "mentee@email.com"
 
#   #  post "/register_post", "role" => "mentor", "username" => "mentor", "password" => "Password1", "confirm_password" => "Password1", "email_address" => "mentor@email.com"
#   #end

#   describe "Post /login-attempt" do
#     it "displays the applications page" do

#       post "/login-attempt", "username" => "mentor", "password" => "Password1"
      
#       get "/index"
#       expect(page).to have_content "SignOut"
#     end 
#   end
# end