require 'date'

class Withdrawal < Sequel::Model
  include Validation
  extend Validation

  def loadWithdrawal(params)
    self.mentee_id = params.fetch("mentee_id", "").strip
    self.mentor_id = params.fetch("mentor_id", "").strip
    self.msg = params.fetch("reason", "").strip
    self.requested_by = params.fetch("role", "").strip
    self.time_stamp = DateTime.now()
  end

  def getMenteeId()
    return self.mentee_id
  end

  def getRole()
    return self.requestee_role
  end

  def self.id_exists?(id)

    return false if id.nil?
    return false unless str_digits?(id)
    return false if Withdrawal[id].nil?

    true
  end
end


