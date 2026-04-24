require "rspec"
require "capybara"

RSpec.describe "Sign Up Button" do
  context "given the Sign up button is clicked" do
    it "shows the register page" do
      # visit home page and click sign up button
      visit "/index"
      click_on "Sign Up"
      expect(page).to  have_content "Register"
    end
  end
end

# RSpec.describe "Menu Button Hover" do
#   context "given the menu button is hovered" do
#     it "shows the menu drop down" do
#       #visits home page and hovers mouse on menu button
#       visit "/header"
#       find('#menuButton').hover
#       expect(page).to have_content "Terms and Conditions"
#       expect(page).to have_content "Register"
#       expect(page).to have_content "Link"
#     end
#   end

#   context "given mentee is loged in and the menu button is hovered" do
#     it "shows the menu with all appropriate options" do
#       #registers as mentee and hovers mouse on menu button
      
      
#       #post "register_post", "role" => "mentee", "username" => "mentee", "password" => "Password1", "confirm_password" => "Password1", "email_address" => "exsample@email.com"
#       find('#menuButton').hover
#       expect(page).to have_content "Terms and Conditions"
#       expect(page).to have_content "Register"
#       expect(page).to have_content "Link"
#       expect(page).to have_content "Home"
#       expect(page).to have_content "Register"
#       expect(page).to have_content "SearchPage"
#       expect(page).to have_content "Profile"
#       expect(page).to have_content "Edit Profile"
#       expect(page).to have_content "Your Match"
#     end
#   end

#   context "given mentor is loged in and the menu button is hovered" do
#     it "shows the menu with all appropriate options" do
#       #registers as mentee and hovers mouse on menu button
      
      
#       post "register_post", "role" => "mentor", "username" => "mentor", "password" => "Password1",
#                               "confirm_password" => "Password1", "email_address" => "exsample@email.com"
#       find('#menuButton').hover
#       expect(page).to have_content "Terms and Conditions"
#       expect(page).to have_content "Register"
#       expect(page).to have_content "Link"
#       expect(page).to have_content "Home"
#       expect(page).to have_content "Register"
#       expect(page).to have_content "Applications"
#       expect(page).to have_content "WaitingList"
#       expect(page).to have_content "Profile"
#       expect(page).to have_content "Edit Profile"
#       expect(page).to have_content "Your Match"
#     end
#   end
# end
