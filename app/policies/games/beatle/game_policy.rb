class Games::Beatle::GamePolicy < GamePolicy
  def join?
    record.collecting?
  end

  def leave?
    super && record.collecting?
  end
end
