module Games
  module Beatle
    class Game < Game
      include Game::PhaseTransitions
      include Game::PhaseRequirements

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
    end
  end
end
