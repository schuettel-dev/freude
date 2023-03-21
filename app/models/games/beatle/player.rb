module Games
  module Beatle
    class Player < Player
      has_one :playlist,
              class_name: "Games::Beatle::Playlist",
              foreign_key: :player_id,
              dependent: :destroy,
              inverse_of: :player

      def setup
        build_playlist
      end
    end
  end
end
