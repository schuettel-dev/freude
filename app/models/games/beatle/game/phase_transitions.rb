module Games
  module Beatle
    class Game
      module PhaseTransitions
        extend ActiveSupport::Concern

        def transit_to_phase
          return unless phase_changed?

          case phase.to_sym
          when :guessing
            prepare_guessing_phase
          when :ended
            prepare_ended_phase
          end
        end

        private

        def prepare_guessing_phase
          playlist_guesses.destroy_all

          players.having_playlist_ready_to_guess.find_each do |player|
            playlists.ready_to_guess
                     .order_by_random
                     .where(player: players.without(player))
                     .find_each do |guessing_playlist|
              PlaylistGuess.create(player:, guessing_player: guessing_playlist.player)
            end
          end
        end

        def prepare_ended_phase
          rank_players_with do
            allocate_points_on_guesses!
            allocate_final_points_for_players!
          end
        end

        def allocate_points_on_guesses!
          playlist_guesses.update_all(allocate_points_on_guesses_sql) # rubocop:disable Rails/SkipsModelValidations
        end

        def allocate_final_points_for_players!
          players.find_each do |player|
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