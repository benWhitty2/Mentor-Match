require "rspec"

RSpec.describe "Applications page" do
  context "given that an account is created" do
    it "redirects to the profile creation page" do
      visit "/register"
      select "Mentee", from: "role"
      fill_in "username", with: "MenteeTest1"
      fill_in "password", with: "TestPassword123"
      fill_in "confirm_password", with: "TestPassword123"
      fill_in "email_address", with: "TestEmail@sheffield.ac.uk"
      check "terms_conditions"
      click_on "Create account"
      

      expect(page).to have_content("Forename")
      expect(page).to have_content("Surname")
      expect(page).to have_content("Description")
      expect(page).to have_content("Gender")
      expect(page).to have_content("Date of Birth")
      expect(page).to have_content("Course")

    end
  end

  context "given no username is entered" do
    it "displays an error message" do
      visit "/register"
      click_on "Create account"

      expect(page).to have_content("Please enter your username")
    end
  end

  context "given password is entered" do
    context "and password isnt strong enough" do
      it "displays an error message" do

        visit "/register"
        select "Mentee", from: "role"
        fill_in "username", with: "MenteeTest1"
        fill_in "password", with: "test"
        fill_in "confirm_password", with: "test"
        fill_in "email_address", with: "TestEmail@sheffield.ac.uk"
        check "terms_conditions"
        click_on "Create account"

        expect(page).to have_content("one uppercase letter")
        expect(page).to have_content("between 8 and 15 characters")
        expect(page).to have_content("at least one number")
      end
    end
  end
  context "given a password is entered" do
    context "and confirm password doesnt match" do
      it "displays an error message" do
        visit "/register"
        select "Mentee", from: "role"
        fill_in "username", with: "MenteeTest1"
        fill_in "password", with: "TestPassword123"
        fill_in "confirm_password", with: "PasswordTest456"
        fill_in "email_address", with: "TestEmail@sheffield.ac.uk"
        check "terms_conditions"
        click_on "Create account"

        expect(page).to have_content("does not match")
      end
    end
  end
end