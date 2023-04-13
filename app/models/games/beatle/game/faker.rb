module Games
  module Beatle
    class Game
      class Faker
        def call!
          raise "This can only run in development" unless Rails.env.development?

          ApplicationRecord.transaction do
            update_playlists!
            move_to_guessing_phase!
            update_playlist_guesses!
            end_game!
          end

          game.user
        end

        private

        def game_template
          @game_template ||= GameTemplate.find_by!(namespace: "Games::Beatle")
        end

        def game
          @game ||= game_template.new_game(group_name:, user: users.first).tap(&:save!)
        end

        def update_playlists!
          players.each do |player|
            player.playlist.update!(
              song_1_url: to_spotify_url(random_string),
              song_2_url: to_spotify_url(random_string),
              song_3_url: to_spotify_url(random_string)
            )
          end
        end

        def move_to_guessing_phase!
          PhaseChangeForm.new(game:, params: { phase: :guessing }).save
        end

        def update_playlist_guesses!
          players.each do |player|
            guessed_players = players.without(player).shuffle
            player.playlist_guesses.each do |playlist_guess|
              playlist_guess.update(guessed_player: guessed_players.pop)
            end
          end
        end

        def end_game!
          PhaseChangeForm.new(game:, params: { phase: :ended }).save
        end

        def group_name
          @group_name ||= "Minions Beatle ##{random_string}"
        end

        def players
          @players ||= users.map do |user|
            game.new_player(user:).tap(&:save!)
          end
        end

        def users
          @users ||= game_template.maximum_players.times.map do
            number = random_number
            User.create!(name: "Minion ##{number}", token: "MINION#{number}TOKEN")
          end
        end

        def random_string
          SecureRandom.alphanumeric(5)
        end

        def random_number
          SecureRandom.rand(10_000..20_000)
        end

        def to_spotify_url(value)
          "https://open.spotify.com/track/#{value}"
        end
      end
    end
  end
end
