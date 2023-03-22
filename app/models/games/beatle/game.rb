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
        return minimal_requirements_for_guessing_phase? if to_phase.to_sym == :guessing

        false
      end

      def minimal_requirements_for_guessing_phase?
        minimum_players_reached? && minimum_players_playlists_ready?
      end

      def minimum_players_playlists_ready?
        Playlist.of_game(self).count(&:ready?) >= game_template.minimum_players
      end
    end
  end
end
