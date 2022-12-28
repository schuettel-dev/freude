class Game::Beatle < Game
  enum phase: {
    collecting: "collecting",
    guessing: "guessing",
    ended: "ended"
  }

  ALLOWED_TRANSITIONS = {
    collecting: %i[guessing],
    guessing: %i[collecting ended],
    ended: []
  }.freeze

  def meets_preconditions_to_transit_to_phase?(to_phase:)
    return true unless to_phase.to_sym == :guessing

    minimum_players_reached?
  end
end
