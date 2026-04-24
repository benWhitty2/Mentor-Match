$confirmation = 0
get "/admin_flagging" do
  @loginSignOut = loginButtonStatus
  @user = User.new
  @userType = session["logedIn"].class.to_s
  if session["logedIn"].nil?
    redirect "/login"
  else
    if @userType == "Admin"
    else
      redirect "/index"
    end
  end
  erb :admin_flagging
end
post "/flagging_post" do
  @loginSignOut = loginButtonStatus
  # check whether the form was actually submitted
  @form_was_submitted = !params.empty?
  # fetch each field from the @params hash (defaulting to
  # empty string if not present) and sanitise
  @username = params.fetch("username", "").strip
  @reason = params.fetch("reason", "").strip 
  @userType = session["logedIn"].class.to_s
  if @form_was_submitted
    # add validation messages
    @username_error = "Please enter a username." if @username.empty?
    @reason_error = "Please enter the reason for your flagging." if @reason.empty?
    @user = User.where(Sequel.ilike(:username, @username)).first
    @Mentee = Mentee.where(Sequel.ilike(:username, @username)).first
    @userRole = "Mentee"
    if @Mentee.nil?
      @Mentor = Mentor.where(Sequel.ilike(:username,@username)).first
      @userRole = "Mentor"
      if @Mentor.nil?
        @invalid_username_error = "Please enter an existing username"
      else
        @username = @Mentor.username
      end
    else
      @username = @Mentee.username
    end
    unless @username_error.nil? && @reason_error.nil? && @invalid_username_error.nil?
      @submission_error = "Please correct the errors below"
    end
    if @submission_error.nil? && $confirmation == 1
      # ... in a real application we would do some processing with the data here ...
      @Mentee = Mentee.where(Sequel.ilike(:username,@username)).first
      if @Mentee.nil?
        @Mentor = Mentor.where(Sequel.ilike(:username,@username)).first
        @Mentor.flagged = 1
        @notify = @username + " has been flagged."
        @reason = ""
        $confirmation = 0
        erb :admin_flagging
      else
        @Mentee.flagged = 1
        @notify = @username + " has been flagged."
        @reason = ""
        $confirmation = 0
        erb :admin_flagging
      end
    else
      if $confirmation == 0 && @submission_error.nil?
        $confirmation = 1
        erb :admin_flagging
      end
    end
  end
  
  erb :admin_flagging
end
