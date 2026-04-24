require "rspec"

RSpec.describe "Matching system" do
  before(:context) do
    post "/register_post", {
      "role" => "mentee", "username" => "mentee",
      "password" => "Password1", "confirm_password" => "Password1",
      "email_address" => "mentee@email.com"
    }

    post "/register_post", {
      "role" => "mentor", "username" => "mentor",
      "password" => "Password1", "confirm_password" => "Password1",
      "email_address" => "mentor@email.com"
    }
  end

  it "allows a mentee to apply to a mentor" do
    post "/login-attempt", "username" => "mentee", "password" => "Password1"
    mentor_id = Mentor.where(username: "mentor").first.id

    post "/match", "mentor_id" => mentor_id

    match = DB[:pending_matches].where(mentee_id: Mentee.where(username: "mentee").first.id, mentor_id: mentor_id).first
    expect(match).not_to be_nil
  end
end
