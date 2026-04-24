RSpec.describe "Register form" do
  describe "GET /register" do
    before(:all) do
      @user = User.where(Sequel.ilike(:username, "Test")).first
      if !@user.nil?
        @user.delete
      end

    end
    it "displays the register page" do
      get "/register"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Please enter your personal information")
    end
  end

  describe "POST /register_post" do
    context "when no data is submitted" do
      it "says there are errors" do
        post "/register_post", "role" => "mentee"
        expect(last_response).to be_ok
        expect(last_response.body).to include("errors")
      end
    end

    context "when data is submitted and it is all valid" do
      it "redirects to the profile creation" do
        visit "/register"
        find('a[href*="terms"]').click
        click_on 'Accept'
        post "register_post", "role" => "mentee", "username" => "Test", "password" => "Aryan1313169",
                              "confirm_password" => "Aryan1313169", "email_address" => "Test@gmail.com"
        click_on 'Create account'
        expect(last_response).to be_redirect                
      end
    end
    context "when only partial data is submitted" do
      it "says there are errors" do
        post "/register_post", "role" => "mentee", "password" => "Aryan1313169",
        "confirm_password" => "Aryan1313169", "email_address" => "Test@gmail.com"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end

    context "when the submitted data is invalid" do
      it "says there are errors" do
        post "/register_post" , "role" => "mentee", "username" => "Test", "password" => "Aryan1313169",
        "confirm_password" => "Aryan1212169", "email_address" => "Test@gmail.com"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end

    context "when the password doesn't satisfy all the criterias" do
      it "says the passwords needs to have these characters" do
        post "/register_post" , "role" => "mentee", "username" => "Test", "password" => "testpassword",
        "confirm_password" => "testpassword", "email_address" => "Test@gmail.com"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end
    context "when the username and email exists in the database" do
      it "says the username or email is taken" do
        post "/register_post" , "role" => "mentee", "username" => "MenteeNum1", "password" => "testpassword",
        "confirm_password" => "testpassword", "email_address" => "Mentee1@gmail.com"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end

  end

end