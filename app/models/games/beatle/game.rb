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
        playlist_guesses.unguessed.none?
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
        players.update_all("final_points = NULL, final_rank = NULL")
        playlist_guesses.update_all("points = CASE WHEN guessed_player_id = guessing_player_id THEN 1 ELSE 0 END")

        self.class.connection.execute(
          <<~SQL.squish
            WITH with_players_final_points AS (
              SELECT p.id            AS player_id
                   , sum(pg.points)  AS final_points
                FROM players p
               INNER JOIN games_beatle_playlist_guesses pg ON pg.player_id = p.id
               WHERE p.game_id = #{id}
               GROUP BY p.id
            )

            UPDATE players p
               SET final_points = fp.final_points
              FROM with_players_final_points fp
             WHERE fp.player_id = p.id
          SQL
        )

        self.class.connection.execute(
          <<~SQL.squish
            WITH with_players_final_rank AS (
              SELECT p.id                                           AS player_id
                   , RANK() OVER (PARTITION BY p.game_id
                                      ORDER BY p.final_points DESC) AS final_rank
                FROM players p
               WHERE p.final_points IS NOT NULL
                 AND p.game_id = #{id}
            )

            UPDATE players p
               SET final_rank = fr.final_rank
              FROM with_players_final_rank fr
             WHERE fr.player_id = p.id
          SQL
        )
      end

      def minimum_players_playlists_ready?
        playlists.ready_to_guess.count >= game_template.minimum_players
      end
    end
  end
end
