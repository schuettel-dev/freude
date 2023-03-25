module Games
  module Beatle
    class Game < Game
      attribute :phase, default: :collecting

      has_many :players, class_name: "Games::Beatle::Player", dependent: :destroy

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

      def playlists
        Playlist.of_game(self)
      end

      def playlist_guesses
        PlaylistGuess.of_game(self)
      end

      def requirements_met_for_guessing_phase?
        minimum_players_reached? && minimum_players_playlists_ready?
      end

      def requirements_met_for_ended_phase?
        false # TODO
      end

      def prepare_guessing_phase
        playlist_guesses.destroy_all

        players.having_playlist_ready_to_guess.find_each do |player|
          playlists.ready_to_guess.where(player: players.without(player)).find_each do |guessing_playlist|
            PlaylistGuess.create(player:, guessing_player: guessing_playlist.player)
          end
        end
      end

      def prepare_ended_phase
        raise "TODO"
      end

      def minimum_players_playlists_ready?
        playlists.ready_to_guess.count >= game_template.minimum_players
      end
    end
  end
end
