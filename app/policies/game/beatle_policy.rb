class Game::BeatlePolicy < GamePolicy
  def join?
    record.collecting?
  end
end
