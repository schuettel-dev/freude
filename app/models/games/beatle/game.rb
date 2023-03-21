module Games
  module Beatle
    class Game < Game
      attribute :phase, default: :collecting

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

      def minimal_requirements_met_for_phase?(to_phase:)
        return minimum_players_reached? if to_phase.to_sym == :guessing

        true
      end
    end
  end
end
