RSpec.describe "Admin register form" do
  before(:all) do
    @user = User.where(Sequel.ilike(:email, "Testing@gmail.com")).first
    @admin = Admin.where(Sequel.ilike(:email, "Testing@gmail.com")).first
    if !@user.nil?
      @user.delete
    end
    if !@admin.nil?
      @admin.delete
    end
  end
  describe "GET /admin_register" do
    it "displays the register page" do
      get "/admin_register"
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Please enter the details for the new admin")
    end
  end
  describe "POST /admin_register_post" do
    context "when no data is submitted" do
      it "says there are errors" do
        get "/admin_register"
        post "/admin_register_post", "email" => ""
        expect(last_response).to be_ok
        expect(last_response.body).to include("errors")
      end
    end

    context "when data is submitted and it is all valid" do
      it "redirects to the main page" do
        get "/admin_register"
        post "admin_register_post", "password" => "Admin1212", "email_address" => "Testing@gmail.com"
        expect(last_response).to be_redirect
      end
    end

    context "when only partial data is submitted" do
      it "says there are errors" do
        post "/admin_register_post", "email_address" => "AdminTest@gmail.com"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end

    context "when the submitted data is invalid" do
      it "says there are errors" do
        post "/admin_register_post" , "email_address" => "AdminTestgmail.com", "password" => "Admin1234"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end
    context "when the password doesn't satisfy all the criterias" do
      it "says the passwords needs to have these characters" do
        post "/admin_register_post" , "email_address" => "AdminTest@gmail.com", "password" => "admin1234"
        expect(last_response.status).to eq(200)
        expect(last_response.body).to include("errors")
      end
    end
  end
end