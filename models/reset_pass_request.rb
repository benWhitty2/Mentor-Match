class ResetPassRequest < Sequel::Model
  def load(params)
    self.id = params.fetch("id", "").strip
  end

end
