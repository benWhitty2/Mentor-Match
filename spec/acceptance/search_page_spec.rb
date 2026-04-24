require "rspec"

RSpec.describe "Search page" do
  before(:context) do
    post "/register_post", {
      "role" => "mentee", "username" => "search_mentee",
      "password" => "Password1", "confirm_password" => "Password1",
      "email_address" => "searchmentee@email.com"
    }

    post "/register_post", {
      "role" => "mentor", "username" => "mathmentor",
      "password" => "Password1", "confirm_password" => "Password1",
      "email_address" => "math@email.com", "course" => "Math"
    }

    post "/register_post", {
      "role" => "mentor", "username" => "physicmentor",
      "password" => "Password1", "confirm_password" => "Password1",
      "email_address" => "physic@email.com", "course" => "Physics"
    }

    post "/login-attempt", "username" => "search_mentee", "password" => "Password1"
  end

  it "returns mentors matching the course" do
    get "/search_page", user_search: "Math"
    expect(page).to have_content "mathmentor"
    expect(page).not_to have_content "physicmentor"
  end

  it "shows ✓ instead of button for matched mentors" do
    mentee = Mentee.where(username: "search_mentee").first
    mentor = Mentor.where(username: "mathmentor").first
    DB[:matches].insert(mentee_id: mentee.id, mentor_id: mentor.id)

    get "/search_page"
    expect(page).to have_content "✓"
  end
end