module Games
  module Beatle
    class Player < Player
      has_one :playlist, class_name: "Games::Beatle::Playlist", dependent: :destroy

      def setup
        build_playlist
      end
    end
  end
end
