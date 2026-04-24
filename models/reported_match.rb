class ReportedMatch < Sequel::Model
  def load(params)
    self.mentor_id = params.fetch("mentor_id", "").strip
    self.mentee_id = params.fetch("mentee_id", "").strip
  end

  def getMenteeId()
    return self.mentee_id
  end
end