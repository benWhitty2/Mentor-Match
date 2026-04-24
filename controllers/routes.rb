require 'digest'
require 'sqlite3'
require 'date'


def loginButtonStatus
  if session["logedIn"] == nil
    return "Login"
  else
    return "SignOut"
  end
end
get "/" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  erb:index
end
# initially send the user to the home page
get "/index" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  erb :index
end


get "/profile_creation" do 
  @userType = session["logedIn"].class.to_s
  @loginSignOut = loginButtonStatus
  erb :profile_creation
end



get "/register" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @role_options = {"mentee" => "Mentee", "mentor" => "Mentor"}
  @user = User.new
    # To be used for getting information right after register
  $userID = @user.id
  erb :register
end

post "/register_post" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @role_options = {"mentee" => "Mentee", "mentor" => "Mentor"}
  # check whether the form was actually submitted
  @form_was_submitted = !params.empty?
  # fetch each field from the @params hash (defaulting to
  # empty string if not present) and sanitise
  @user = User.new
  @user.loadRegister(params)
  @role = params.fetch("role", "").strip 
  @confirm_password = params.fetch("confirm_password", "").strip
  
  if @form_was_submitted
    # add validation messages
    @role_error = "Please enter a valid role." if !@role_options.key?(@role)
    @username_error = "Please enter your username." if @user.username.empty?
    @same_username_error = "This username is already taken." unless User.first(username: @user.username).nil?
    # password checks for a secure password
    if @user.pass.empty?
      @password_empty_error = "Please enter a password."
    else
      # checks length of password
      if @user.pass.length < 8 || @user.pass.length > 15
        @password_error = "Please make sure the password has between 8 and 15 characters."
      end
      # check for a number
      unless @user.pass =~ /\d/
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one number."
        else 
          @password_error = "Please make sure the password has between 8 and 15 characters and at least one number."
        end
      end
      # check for a lowercase letter
      unless @user.pass =~ (/[a-z]/)
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one lowercase letter"
        else
          @password_error = "Please make sure the password has at least one lowercase letter"
          if @user.pass.length < 8 || @user.pass.length > 15
            @password_error += " and has between 8 and 15 characters"
          end
          unless @user.pass =~ /\d/
            @password_error += " and at least one number"
          end
          @password_error += "."
        end
      end
      # check for an uppercase letter
      unless @user.pass =~ (/[A-Z]/)
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one uppercase letter"
        else
          @password_error = "Please make sure the password has at least one uppercase letter"
          if @user.pass.length < 8 || @user.pass.length > 15
            @password_error += " and has between 8 and 15 characters"
          end
          unless @user.pass =~ /\d/
            @password_error += " and at least one number"
          end
          unless @user.pass =~ (/[a-z]/)
            @password_error += " and at least one lowercase letter"
          end
          @password_error += "."
        end
      end
    end
    @confirmation_empty_error = "Enter your password again." if @confirm_password.empty?
    @confirmation_error = "This does not match with your password." if @user.pass != @confirm_password
    @email_address_error = "Please enter a valid email address." unless str_email_address?(@user.email)
    @same_email_address_error = "This email already exists. Please log in instead." unless User.first(email: @user.email).nil?
  end
    unless @role_error.nil? && (@username_error.nil? && @same_username_error.nil?) && (@password_empty_error.nil? && @password_error.nil?) && (@confirmation_error.nil? || @confirmation_empty_error) && (@email_address_error.nil? && @same_email_address_error.nil?)
      @submission_error = "Please correct the errors below"
    end
    if @submission_error.nil?# && @user.encrypt(@user.pass)
      # ... in a real application we would do some processing with the data here ...
      @user.save_changes
      if @role == "mentee"
        @newMentee = Mentee.new
        @newMentee.username = @user.username
        @newMentee.encrypt(@user.pass)
        @newMentee.email= @user.email
        @newMentee.photo_file = "images/placeholder-image.jpg"
        @newMentee.save_changes
        session["logedIn"] = @newMentee
        redirect "/profile_creation"
      else if @role == "mentor"
        @newMentor = Mentor.new
        @newMentor.username = @user.username
        @newMentor.encrypt(@user.pass)
        @newMentor.email= @user.email
        @newMentor.mentee_cap = 2
        @newMentor.photo_file = "images/placeholder-image.jpg"
        @newMentor.save_changes
        session["logedIn"] = @newMentor
        redirect "/profile_creation"
      end

    end
  end
  
  erb :register
end

get "/admin_register" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @admin = Admin.new
  erb :admin_register
end

post "/admin_register_post" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  # check whether the form was actually submitted
  @form_was_submitted = !params.empty?
  # fetch each field from the @params hash (defaulting to
  # empty string if not present) and sanitise
  @admin = Admin.new
  @admin.loadRegister(params)
  if @form_was_submitted
    # add validation messages
    @email_address_error = "Please enter a valid email address" unless str_email_address?(@admin.email)
    @same_email_address_error = "This email already exists. Enter a different email." unless Admin.first(email: @admin.email).nil?
    # password checks for a secure password

    if @admin.pass.empty?
      @password_empty_error = "Please enter a password."
    else
      # checks length of password
      if @admin.pass.length < 8 || @admin.pass.length > 15
        @password_error = "Please make sure the password has between 8 and 15 characters."
      end
      # check for a number
      unless @admin.pass =~ /\d/
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one number."
        else 
          @password_error = "Please make sure the password has between 8 and 15 characters and at least one number."
        end
      end
      # check for a lowercase letter
      unless @admin.pass =~ (/[a-z]/)
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one lowercase letter"
        else
          @password_error = "Please make sure the password has at least one lowercase letter"
          if @admin.pass.length < 8 || @admin.pass.length > 15
            @password_error += " and has between 8 and 15 characters"
          end
          unless @admin.pass =~ /\d/
            @password_error += " and at least one number"
          end
          @password_error += "."
        end
      end
      # check for an uppercase letter
      unless @admin.pass =~ (/[A-Z]/)
        if @password_error.nil?
          @password_error = "Please make sure the password has at least one uppercase letter"
        else
          @password_error = "Please make sure the password has at least one uppercase letter"
          if @admin.pass.length < 8 || @admin.pass.length > 15
            @password_error += " and has between 8 and 15 characters"
          end
          unless @admin.pass =~ /\d/
            @password_error += " and at least one number"
          end
          unless @admin.pass =~ (/[a-z]/)
            @password_error += " and at least one lowercase letter"
          end
          @password_error += "."
        end
      end
    end
  end
  unless (@password_empty_error.nil? && @password_error.nil?) && (@email_address_error.nil? && @same_email_address_error.nil?)
    @submission_error = "Please correct the errors below"
  end
  
  if @submission_error.nil? && @admin.encrypt(@admin.pass)
    # ... in a real application we would do some processing with the data here ...
    @admin.save_changes
    redirect "/profile"
  end
  
  erb :admin_register
end

post "/profile_creation" do 
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @form_was_submitted = !params.empty?
  @user = session["logedIn"]
  @forename = params.fetch("forename","").strip
  @surname = params.fetch("surname","").strip
  @desc = params.fetch("desc","").strip
  @gender = params.fetch("gender","").to_s.strip
  @date_of_birth = params.fetch("date_of_birth","").to_s.strip
  @course = params.fetch("course","").strip
  @year_of_study = params.fetch("year_of_study","").to_s.strip
  

  if @form_was_submitted
    if @forename.empty? || @surname.empty? || @desc.empty? || @course.empty? || @year_of_study.empty? || @gender.empty? || @date_of_birth.empty?
      @empty_error = "Please fill out all the fields."
      erb :profile_creation
    else
      if @userType == "Mentor" && (@year_of_study.to_i<2 || @year_of_study.to_i>10)
        @integer_error = "Please enter a number of 2 or more."
        erb :profile_creation
      else

        @user.first_name = @forename
        @user.surname = @surname
        @user.bio = @desc
        @user.gender = @gender
        @user.date_of_birth = @date_of_birth
        @user.course = @course
        @user.year_of_study = @year_of_study
        @user.save_changes
        session["logedIn"] = @user
        redirect "/profile"
      end
    end
  end
end

get "/terms" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  erb :terms
end

post "/terms_process" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  if params["accepted"] == "Accept"
    $termsAccepted = true
    redirect "/register"
  else
    @decline = "To register for this website, you must accept the terms and conditions."
    erb :terms
  end 
end

get "/profile" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s

  if session["logedIn"]
    user = session["logedIn"]
    if @user.class == Mentor
      @user=[user.name,user.bio,user.username,user.gender,user.date_of_birth,user.course,user.year_of_study,user.photo_file,user.experienced_mentor] 
    else
      @user=[user.name,user.bio,user.username,user.gender,user.date_of_birth,user.course,user.year_of_study,user.photo_file] 
    end
    erb :profile
  else
    redirect "/login"
  end
end

get "/new-pass" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  erb :new_pass
end

post "/new-pass" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  puts params["password"]
  puts params["newPassword"]
  @user = session["logedIn"]
  if session["logedIn"] != nil && @user.compare(params["password"])
    if params["newPassword"] == params["checkPassword"]
      @user.encrypt(params["newPassword"])
      @user.save_changes
      redirect "profile"
    else
      @new_pass_response = "passwords don't match"
      erb :new_pass
    end
  else
    @new_pass_response = "password invalid!"
    erb :new_pass
  end
end

get "/search_page" do
  if session["logedIn"].class == Mentee && !Match.where(mentee_id: session["logedIn"].id).any?
    @loginSignOut = loginButtonStatus
    @userType = session["logedIn"].class.to_s
    @user_search = params.fetch("user_search", "").strip

    @current_user = session["logedIn"]
    mentee_id = @current_user[:id]

    matched_ids = DB[:matches].where(mentee_id: mentee_id).select_map(:mentor_id)
    pending_ids = DB[:pending_matches].where(mentee_id: mentee_id).select_map(:mentor_id)

    @already_applied_or_matched = matched_ids | pending_ids # Union of both arrays

    base_query = DB[:mentors]
    base_query = base_query.where(Sequel.ilike(:course, "%#{@user_search}%")) unless @user_search.empty?

    @mentors = base_query.select(:first_name, :surname, :gender, :date_of_birth, :course, :year_of_study, :bio, :id).all

    erb :search_page
  else
    redirect "/index"
  end
end


post "/match" do
  if session["logedIn"].class == Mentee && !Match.where(mentee_id: session["logedIn"].id).any?
    @loginSignOut = loginButtonStatus
    @userType = session["logedIn"].class.to_s
    mentor_id = params[:mentor_id]
    mentee_id = session["logedIn"][:id]  # from session

    if mentor_id && mentee_id
      # Avoid duplicate matches
      unless DB[:pending_matches].where(mentor_id: mentor_id, mentee_id: mentee_id).any?
        DB[:pending_matches].insert(mentor_id: mentor_id, mentee_id: mentee_id)
        if session["logedIn"][:first_application] == nil
          @user = session["logedIn"]
          @user.first_application = Date.today
          @user.save_changes
        end
      end
    end
    redirect "/search_page"
  else
    redirect "/index"
  end
end


get "/update" do
  @img_src = "images/placeholder-image.jpg"
  erb :img_update
end

post "/upload" do
  @user = session["logedIn"]
  filename = params[:file][:filename]
  tmpfile = params[:file][:tempfile]
  filesize = tmpfile.size.to_f
  
  if (filesize / (1024.0 ** 2) > 5)
    @filesize_error = "Image is too big please pick an image smaller than 5Mb"
    erb :img_update
  else
    @filesize_error = nil
    src = "./public/images/"
    duplicate_count = 0
    if not File.exist?(src + filename)
      FileUtils.copy(tmpfile.path, src + filename)
    else
      duplicate_count = 1
      while File.exist?(src + filename + '(' + duplicate_count.to_s + ')')
        duplicate_count += 1
      end
      FileUtils.copy(tmpfile.path, src + filename + '(' + duplicate_count.to_s + ')')
    end
    if duplicate_count.zero?
      @img_src = "/images/" + filename
    else
      @img_src = "/images/" + filename + '(' + duplicate_count.to_s + ')'
    end
    @user.photo_file = @img_src
    @user.save_changes
  end
  
  erb :img_update
end

get "/view-match" do
  user = session["logedIn"]
  if (user.class == Mentee && Match.where(mentee_id: user.id).any?) || (user.class == Mentor && Match.where(Sequel.ilike(:mentor_id, user.id)).any?)
    @loginSignOut = loginButtonStatus
    @userType = session["logedIn"].class.to_s
    if user.class == Mentor
      mentee_id = Match.where(mentor_id: user.id).first.mentee_id
      user = Mentee.where(id: mentee_id).first
      @user=[user.name,user.bio,user.username,user.gender,user.date_of_birth,user.course,user.year_of_study,user.photo_file] 
      erb :view_match
    else
      mentor_id = Match.where(mentee_id: user.id).first.mentor_id
      user = Mentor.where(id: mentor_id).first
      @user=[user.name,user.bio,user.username,user.gender,user.date_of_birth,user.course,user.year_of_study,user.photo_file,user.experienced_mentor] 
      erb :view_match
    end
  else
    redirect "/index"
  end
end



get "/edit_profile" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @role_options = {"mentee" => "Mentee", "mentor" => "Mentor"}
  if session["logedIn"]
    username = session["logedIn"].username
    user = Mentee.where(Sequel.ilike(:username, username)).first
    if user.nil?
      user = Mentor.where(Sequel.ilike(:username, username)).first
      @year_of_study = user.year_of_study
    end
    @first_name = user.first_name
    @surname = user.surname
    @bio = user.bio
    @gender = user.gender
    @course = user.course
    
    erb :edit_profile
  else
    redirect "/login"
  end
end



post "/edit_profile" do
  @form_was_submitted = !params.empty?
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  @forename = params.fetch("forename","").strip
  @surname = params.fetch("surname","").strip
  @bio = params.fetch("desc","").strip
  @gender = params.fetch("gender","").to_s.strip
  @course = params.fetch("course","").strip
  @year_of_study = params.fetch("year_of_study","").to_s.strip
  if @form_was_submitted
    if @forename.empty? || @surname.empty? || @bio.empty? || @course.empty? || @year_of_study.empty? || @gender.empty?
      @empty_error = "Please fill out all the fields."
      erb :edit_profile
    else
      if @userType == "Mentor" && (@year_of_study.to_i<2 || @year_of_study.to_i>10)
        @integer_error = "Please enter a number of 2 or more."
        erb :edit_profile
      else
        @user = session["logedIn"]
        @user.first_name = @forename
        @user.surname = @surname
        @user.bio = @bio
        @user.gender = @gender
        @user.course = @course
        if @user.class == Mentor
          @user.year_of_study = @year_of_study
        end
        @user.save_changes
        redirect "/profile"
      end
    end
  else
    @empty_error = "Please fill out all the fields."
    erb :edit_profile
  end
end
    