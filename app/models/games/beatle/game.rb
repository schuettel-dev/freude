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

      def requirements_met_for_guessing_phase?
        minimum_players_reached? && minimum_players_playlists_ready?
      end

      def requirements_met_for_ended_phase?
        false # TODO
      end

      def prepare_guessing_phase
        raise "TODO"
      end

      def prepare_ended_phase
        raise "TODO"
      end

      def minimum_players_playlists_ready?
        Playlist.of_game(self).count(&:ready?) >= game_template.minimum_players
      end
    end
  end
end
