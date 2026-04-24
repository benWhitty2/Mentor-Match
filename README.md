# Description
This program is a web application designed to be used by a university to match higher year mentors to lower year mentees. Where both parties have a choice over who they are matched with. This is accomplished by allowing all mentees to send machine requests to mentors who can then accept them at their discretion.

Commands for installing/starting the program:
git clone git@git.shefcompsci.org.uk:com1001-2024-25/team45/project.git
cd project

# Requirments
- Sinatra
- puma, falcon, thin, webrick

# To start the program
run $ruby app.rb

# How to run the test
run $rspec spec/controllers/routes_spec.rb

# Demonstration video 
https://drive.google.com/file/d/13yC6O3Y0UDCMpSueRnJ5hPyRTCyTHvd3/view?usp=drive_link

# Contributors 
This project was developed by 6 people 
- Benjamin Whittaker
- Aayan Akhter 
- Can JM Oksuzcan 
- Claire M Down 
- Matthias Jones 
- Sophie L Thompson

# My contributions
I Created login, new-password, reset-password, waiting list, view-application, and view-reset pages.
Cerated methods for comparing password to encrypted password, getting Waiting list, mentees applying to a mentor, rejecting applications, reporting applications, accepting applications(creating a new match)
Created login.css
Created final testing database
Created dynamic menu system and displayed login status to all pages

# Users
There are a number of pre initialised users on the system for inspecting its functionality and they are as follows.

All Password for these users are the same as there usernames.
- WeekOldMentee1
- Mentor11
- Mentor22
- Mentor33
- Mentee11
- Mentee22
- Mentee33

- admintest@gmail.com(password: Admin1234)


