require "test_helper"

class Games::Beatle::Game::PhaseTransitionsTest < ActiveSupport::TestCase
  test "#transit_to_phase, from: :collecting, to: :guessing" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    kramers_playlist = games_beatle_playlists(:kramer_player_in_beatle_seinfeld_playlist)
    kramers_playlist.update!(
      song_1_url: "https://wrong",
      song_2_url: nil,
      song_3_url: nil
    )

    Games::Beatle::PlaylistGuess.of_game(game).delete_all

    assert_changes -> { game.reload.phase }, to: "guessing" do
      assert_changes -> { Games::Beatle::PlaylistGuess.of_game(game).reload.count }, from: 0, to: 6 do
        game.guessing!
      end
    end
  end

  test "#transit_to_phase, from: :guessing, to: :ended" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)

    jerry, elaine, george, kramer = players(
      :jerry_player_in_beatle_seinfeld,
      :elaine_player_in_beatle_seinfeld,
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).each do |player|
      player.update!(final_points: 999, final_rank: 1)
    end

    game.ended!

    assert_equal [1, 2], jerry.reload.values_at(:final_points, :final_rank)
    assert_equal [3, 1], elaine.reload.values_at(:final_points, :final_rank)
    assert_equal [0, 4], george.reload.values_at(:final_points, :final_rank)
    assert_equal [1, 2], kramer.reload.values_at(:final_points, :final_rank)
  end

  test "#transit_to_phase, from: :guessing, to: :collecting" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)

    assert_changes -> { game.reload.phase }, to: "collecting" do
      game.collecting!
    end
  end
end
