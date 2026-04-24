class Matches < Sequel::Model
  include Validation
  extend Validation


  def loadMatch(param)
    self.mentor_id = params.fetch("mentor_id", "").strip
    self.mentee_id = params.fetch("mentee_id", "").strip
  end

  def getMenteeId()
    return self.mentee_id
  end

  def getMentorId()
    return self.mentor_id
  end

  def self.id_exists?(mentee_id)
    return false if mentee_id.nil?
    return false unless str_digits?(mentee_id)
    return false if Matches[mentee_id].nil?
    
    true
  end
end