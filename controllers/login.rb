get "/login" do
  session["logedIn"] = nil
  @loginSignOut = "Login"
  erb :login
end

post "/login-attempt" do
  @user = Mentee.where(Sequel.ilike(:username, params["username"])).first
  if @user.nil?
    @user = Mentor.where(Sequel.ilike(:username, params["username"])).first
  end
  if @user.nil?
    @user = Admin.where(Sequel.ilike(:email, params["username"])).first
  end

  if @user != nil && @user.compare(params["password"])
    puts params["username"] + " has loged in"
    session["logedIn"] = @user
    redirect to("/index")
  else
    puts "a user has failed to login"
    @loginSignOut = "Login"
    @username = params["username"]
    @login_error = "username or password incorrect"
    erb :login
  end
end

get "/reset-pass" do
  @loginSignOut = "Login"
  erb :reset_pass
end

post "/reset-pass-attempt" do
  @loginSignOut = "Login"
  @user = Mentee.where(Sequel.ilike(:username, params["username"])).first
  if @user.nil?
    @user = Mentor.where(Sequel.ilike(:username, params["username"])).first
  end

  if @user.nil?
    @rest_pass_respons = "username not found"
  elsif !requestExsits(@user)
    #creates new request only if there is no existing request
    @newRequest = ResetPassRequest.new
    @newRequest.id = @user.id
    if @user.class == Mentor
      @newRequest.stored = true
    else
      @newRequest.stored = false
    end
    @newRequest.save_changes
    @rest_pass_respons = "reset request loged"
  else
    @rest_pass_respons = "reset request already loged"
  end
  erb :reset_pass
end

def requestExsits(user)
  #checks if a request for a account exist in the system

  if user.class == Mentor && ResetPassRequest.where(id: user.id, stored: true).any?
    return true
  end
  if user.class == Mentee 
    return ResetPassRequest.where(id: user.id, stored: false).any?
  end
  return false
end


def getResets
  #get mentee and mentor requests
  mentees = ResetPassRequest.where(Sequel.ilike(:stored, 0)).all
  mentors = ResetPassRequest.where(Sequel.ilike(:stored, 1)).all
  #returns list of mentee and mentor objects
  accounts = []
  for x in 0...mentees.length do
    accounts.append([
      Mentee.where(Sequel.ilike(:id, mentees[x].id)).first.username,
      Mentee.where(Sequel.ilike(:id, mentees[x].id)).first.id,
      Mentee.where(Sequel.ilike(:id, mentees[x].id)).first.class])
  end
  for x in 0...mentors.length do
    accounts.append([
      Mentor.where(Sequel.ilike(:id, mentors[x].id)).first.username,
      Mentor.where(Sequel.ilike(:id, mentors[x].id)).first.id,
      Mentor.where(Sequel.ilike(:id, mentors[x].id)).first.class])
  end
  return accounts
end


get "/view-resets" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user admin
  if session["logedIn"].class == Admin
    @applicants = getResets
    erb :view_resets
  else
    erb :index
  end
end



post "/view-resets" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user is admin
  if session["logedIn"].class == Admin && params["newPassword"] != nil
    #set new password
    if params["type"] == "Mentor"
      @resetUser = Mentor.where(Sequel.ilike(:id, params["reset"])).first
    else
      @resetUser = Mentee.where(Sequel.ilike(:id, params["reset"])).first
    end
    @resetUser.encrypt(params["newPassword"])
    @resetUser.save_changes

    #deletes resets pass request
    requests = ResetPassRequest.where(Sequel.ilike(:id, params["reset"])).all

    for i in 0...requests.length do
      #getClass get the bit value repsenting mentor or mentee
      if @resetUser.class == Mentor && requests[i].stored == true
        requests[i].delete
        break
      elsif @resetUser.class == Mentee && requests[i].stored == false
        requests[i].delete
        puts "succes"
        break
      end
    end

    @applicants = getResets
    erb :view_resets
  else
    erb :index
  end
end

