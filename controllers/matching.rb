require 'sqlite3'
require 'date'

def receveApplications(mentor_id)
  return session["logedIn"].class == Mentor &&
  Match.where(Sequel.ilike(:mentor_id, session["logedIn"].id)).all.length < session["logedIn"].mentee_cap
end

def newMatch(mentee_id,mentor)
  if !Match.where(mentee_id: mentee_id).any?
    #creates new match
    @newMatch = Match.new
    @newMatch.mentee_id = mentee_id
    @newMatch.mentor_id = mentor.id
    @newMatch.save_changes

    #if mentee_cap is reached deletes all other pending applications to this mentor
    if Match.where(Sequel.ilike(:mentor_id, mentor.id)).all.length >= mentor.mentee_cap
      pendingMatches = PendingMatch.where(Sequel.ilike(:mentor_id, session["logedIn"].id)).delete
    end
    #delete all pending matches of the newly matched mentee
    pendingMatches = PendingMatch.where(Sequel.ilike(:mentee_id, mentee_id)).delete
  end
end

def getWaitingList
  mentees = Mentee.all
  waitinglist = []
  for i in 0...mentees.length do
    #if user has not been matched 7 days after their first application they are placed on the waitinglist
    if mentees[i].first_application != nil && ((mentees[i].first_application+7)<=(Date.today)) && 
        !Match.where(mentee_id: mentees[i].id).any?

      waitinglist.append([mentees[i].username,mentees[i].course,
      mentees[i].date_of_birth,mentees[i].bio,mentees[i].id])
    end
  end
  return waitinglist
end

get "/view-waitinglist" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])
    @applicants = getWaitingList

    erb :view_waitinglist
  else
    erb :index
  end
end

get "/view-applications" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])
    @applicants = session["logedIn"].getApplications
    erb :view_applications
  else
    erb :index
  end
end


post "/accept-waitinglist" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])

    #creates new match between logedIn mentor and selected mentee
    newMatch(params["accepted"],session["logedIn"])
    @applicants = getWaitingList
    erb :view_waitinglist
  else
    erb :index
  end
end


post "/accept-application" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])

    #creates new match between logedIn mentor and selected mentee
    newMatch(params["accepted"],session["logedIn"])
  
    @applicants = session["logedIn"].getApplications
    erb :view_applications
  else
    erb :index
  end
end

post "/reject-application" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])
    
    mentee_id = params["rejected"]

    #deletes pendingApplication
    pendingMatches = PendingMatch.where(Sequel.ilike(:mentee_id, mentee_id)).all
    for x in 0...pendingMatches.length do
      if pendingMatches[x].mentor_id == session["logedIn"].id
        pendingMatches[x].delete
        break
      end
    end
    @applicants = session["logedIn"].getApplications
    erb :view_applications
  else
    erb :index
  end
end

post "/report-application" do
  @loginSignOut = loginButtonStatus
  @userType = session["logedIn"].class.to_s
  #checks if user eligible for applications
  if receveApplications(session["logedIn"])
    
    mentee_id = params["reported"]

    #adds application to reported list and removes from pending
    pendingMatches = PendingMatch.where(Sequel.ilike(:mentee_id, mentee_id)).all
    for x in 0...pendingMatches.length do
      if pendingMatches[x].mentor_id == session["logedIn"].id
        @newReportedMatch = ReportedMatch.new
        @newReportedMatch.mentee_id = pendingMatches[x].mentee_id
        @newReportedMatch.mentor_id = pendingMatches[x].mentor_id
        @newReportedMatch.save_changes
        pendingMatches[x].delete
        break
      end
    end
  end
  @applicants = session["logedIn"].getApplications
  erb :view_applications
end