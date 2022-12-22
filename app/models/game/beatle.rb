class Game::Beatle < Game
  enum state: {
    collecting: "collecting",
    guessing: "guessing",
    ended: "ended"
  }

  ALLOWED_TRANSITIONS = {
    collecting: %i[guessing],
    guessing: %i[collecting ended],
    ended: []
  }.freeze

  def meets_preconditions_to_transit_to_state?(to_state:)
    return true unless to_state.to_sym == :guessing

    minimum_players_reached?
  end
end
