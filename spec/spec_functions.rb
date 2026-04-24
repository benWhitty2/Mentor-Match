def spec_before
  User.dataset.delete
  Mentee.dataset.delete
  Mentor.dataset.delete
  Matches.dataset.delete
  Withdrawal.dataset.delete
end

