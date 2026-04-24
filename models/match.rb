class Match < Sequel::Model


  def load(params)
    self.mentor_id = params.fetch("mentor_id", "").strip
    self.mentee_id = params.fetch("mentee_id", "").strip
  end

  def getMenteeId()
    return self.mentee_id
  end

  def getMentorId()
    return self.mentor_id
  end

  def setMentorId(newId)
    self.mentor_id = newId
  end

  def setMenteeId(newId)
    self.mentee_id = newId
  end
end