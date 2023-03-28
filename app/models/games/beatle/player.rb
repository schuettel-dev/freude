module Games
  module Beatle
    class Player < Player
      belongs_to :game, class_name: "Games::Beatle::Game"

      has_one :playlist, class_name: "Games::Beatle::Playlist", dependent: :destroy
      has_many :playlist_guesses, dependent: :destroy

      scope :having_playlist_ready_to_guess, -> do
        joins(:playlist).where(games_beatle_playlists: { ready_to_guess: true })
      end

      def setup
        build_playlist
      end
    end
  end
end
