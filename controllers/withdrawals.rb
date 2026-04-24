get "/withdrawal_request" do
  @loginSignOut = loginButtonStatus
  erb :withdrawal_request
end



def match_exists(mentor_id, mentee_id)
  return false if (mentee_id.nil? || mentor_id.nil?)
  return false unless Matches.id_exists?(mentee_id)
  return false unless Matches[mentee_id].getMentorId() == mentor_id.to_i
  puts true

  true
end

post "/withdrawal_request" do
  userType = session["logedIn"].class
  @mentee_user = params[:username].to_s.strip
  @mentee = Mentee.where(Sequel.ilike(:username, @mentee_user)).first

  unless @mentee && Matches.id_exists?(@mentee.id.to_s)
    @error_message = "Please make sure the username is correct and/or is matched with you"
    return erb :withdrawal_request
  end


  if userType == Mentor
    @mentor_id = session["logedIn"].id
    puts @mentee.id
    puts @mentor_id
    puts match_exists(@mentor_id.to_s, @mentee.id.to_s)
    unless match_exists(@mentor_id.to_s, @mentee.id.to_s)
      @error_message = "Match doesn't exist"
      return erb :withdrawal_request
    end
  else
    @mentor_id = Matches[@mentee.id].getMentorId()
  end

  @reason = params[:reason].to_s.strip
  if @reason.empty?
    @empty_error = "Fill in the reason for your withdrawal request."
    return erb :withdrawal_request
  end

  @withdrawal = Withdrawal.new
  attributes = params.dup
  attributes[:mentee_id] = @mentee.id.to_s
  attributes[:mentor_id] = @mentor_id.to_s
  attributes[:role] = userType.to_s
  puts "withdrawal created"
  @withdrawal.loadWithdrawal(attributes)
  @withdrawal.save_changes

  @withdrawals = Withdrawal.all

  (@withdrawals).each do |info|
    puts info.id
  end
  redirect "/profile"

end

get "/withdrawals" do
  @loginSignOut = loginButtonStatus
  @user = User.new
  @userType = session["logedIn"].class.to_s
  if session["logedIn"].nil?
    redirect "/index"
  else
    if @userType == "Admin"
    else
      redirect "/index"
    end
  end
  @withdrawals = Withdrawal.all
  erb :admin_withdrawals
end

post "/reject" do
  id = params.fetch("id", "").strip()

  if Withdrawal.id_exists?(id)
    withdrawal = Withdrawal[id]
    withdrawal.delete
    puts "withdrawal deleted"
  end
  redirect "/withdrawals"

end

post "/accept" do
  id = params.fetch("id", "").strip()
  mentee = params.fetch("mentee", "").strip()

  puts id
  puts mentee 

  if Withdrawal.id_exists?(id)
    puts "withdrawal exists"
    withdrawal = Withdrawal[id]
    if Matches.id_exists?(mentee)
      match = Matches[mentee]
      match.delete
      puts "match deleted"
    end
    withdrawal.delete
  end
  redirect "/withdrawals"
  
end