module Games
  module Beatle
    class Game
      class PhasePreparations
        def initialize(game:, phase:)
          @game = game
          @phase = phase
        end

        def prepare!
          case phase.to_sym
          when :guessing
            prepare_guessing_phase
          when :ended
            prepare_ended_phase
          end
        end

        private

        attr_reader :game, :phase

        def prepare_guessing_phase
          game.playlist_guesses.destroy_all
          create_playlist_guesses
        end

        def create_playlist_guesses
          game.players.having_playlist_ready_to_guess.find_each do |player|
            game.playlists
                .ready_to_guess
                .order_by_random
                .where(player: game.players.without(player))
                .find_each do |guessing_playlist|
              PlaylistGuess.create(player:, guessing_player: guessing_playlist.player)
            end
          end
        end

        def prepare_ended_phase
          Game::RankPlayersWith.new(game).call do
            allocate_points_on_guesses!
            allocate_final_points_for_players!
          end
        end

        def allocate_points_on_guesses!
          game.playlist_guesses.update_all(allocate_points_on_guesses_sql) # rubocop:disable Rails/SkipsModelValidations
        end

        def allocate_final_points_for_players!
          game.players.find_each do |player|
            player.update(final_points: player.playlist_guesses.sum(:points))
          end
        end

        def allocate_points_on_guesses_sql
          <<~SQL.squish
            points = CASE
                       WHEN guessed_player_id = guessing_player_id
                       THEN 1
                       ELSE 0
                     END
          SQL
        end
      end
    end
  end
end
