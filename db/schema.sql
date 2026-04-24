CREATE TABLE users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  first_name TEXT,
  surname TEXT,
  gender TEXT,
  bio TEXT,
  course TEXT,
  date_of_birth TEXT,
  email TEXT,
  year_of_study INTEGER,
  flagged INTEGER,
  pass BLOB,
  salt BLOB,
  iv BLOB
);


CREATE TABLE mentees(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  first_name TEXT,
  surname TEXT,
  gender TEXT,
  bio TEXT,
  course TEXT,
  date_of_birth TEXT,
  email TEXT,
  year_of_study INTEGER,
  flagged INTEGER,
  pass BLOB,
  salt BLOB,
  iv BLOB,
  photo_file TEXT,
  first_application DATE
);

CREATE TABLE mentors(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  first_name TEXT,
  surname TEXT,
  gender TEXT,
  bio TEXT,
  course TEXT,
  date_of_birth TEXT,
  email TEXT,
  year_of_study INTEGER,
  flagged INTEGER,
  mentee_cap INTEGER,
  experienced_mentor BIT,
  pass BLOB,
  salt BLOB,
  iv BLOB,
  photo_file TEXT
);

CREATE TABLE matches(
  mentee_id INTEGER PRIMARY KEY,
  mentor_id INTEGER
);

CREATE TABLE pending_matches(
  mentor_id INTEGER,
  mentee_id INTEGER,
  PRIMARY KEY (mentor_id, mentee_id)
);

CREATE TABLE reported_matches(
  mentor_id INTEGER,
  mentee_id INTEGER,
  PRIMARY KEY (mentor_id, mentee_id)
);

CREATE TABLE reset_pass_requests(
  id INTEGER,
  stored BIT,
  PRIMARY KEY (id, stored)
);

CREATE TABLE withdrawals(
  id INTEGER PRIMARY KEY,
  mentee_id INTEGER,
  mentor_id INTEGER,
  requested_by TEXT,
  time_stamp TEXT,
  msg TEXT
);

CREATE TABLE admins(
  admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  email TEXT,
  pass BLOB,
  salt BLOB,
  iv BLOB
);

