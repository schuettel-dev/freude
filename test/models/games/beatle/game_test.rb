require "test_helper"

class Games::Beatle::GameTest < ActiveSupport::TestCase
  test "#save!" do
    game = Games::Beatle::Game.new(
      name: "name",
      description: "Description",
      group_name: "Group game",
      game_template: game_templates(:beatle),
      user: users(:jerry),
      minimum_players: 3,
      activated_players: 10,
      maximum_players: 30
    )

    assert_difference -> { Game.count }, +1 do
      assert game.save!
    end

    assert_predicate game, :collecting?
    assert_match(/^[[:alnum:]]{6,}$/, game.url_identifier)
    assert_match(/^[[:alnum:]]{5,}$/, game.join_token)
  end

  test "#new_player" do
    game = games(:beatle_seinfeld)
    user = users(:newman)

    assert_difference -> { Games::Beatle::Playlist.count }, +1 do
      assert_difference -> { Games::Beatle::Player.count }, +1 do
        game.new_player(user:)
        game.save!
      end
    end
  end

  test "not #save!" do
    game = Games::Beatle::Game.new

    assert_no_difference -> { Game.count } do
      assert_not game.save
    end

    game.errors.to_a.tap do |errors|
      assert_includes errors, "Group name can't be blank"
      assert_includes errors, "User must exist"
      assert_includes errors, "Game template must exist"
    end
  end

  test "#next_phase" do
    game = Games::Beatle::Game.new(phase: :collecting)

    assert_equal :guessing, game.next_phase

    game.phase = :guessing

    assert_equal :ended, game.next_phase

    game.phase = :ended

    assert_nil game.next_phase
  end

  test "#next_phase?" do
    game = Games::Beatle::Game.new

    assert_not game.next_phase?(:collecting)
    assert game.next_phase?(:guessing)
    assert_not game.next_phase?(:ended)
  end

  test "#minimum_players_reached?" do
    game = games(:beatle_seinfeld)
    excluding_players = players(:jerry_player_in_beatle_seinfeld, :elaine_player_in_beatle_seinfeld)

    assert_changes -> { game.minimum_players_reached? }, to: false do
      game.players.excluding(excluding_players).destroy_all
    end
  end

  test "#transition_allowed?, from: :collecting" do
    game = games(:beatle_seinfeld)
    game.phase = :collecting

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :guessing" do
    game = games(:beatle_seinfeld)
    game.phase = :guessing

    assert game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :ended" do
    game = games(:beatle_seinfeld)
    game.phase = :ended

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end

  test "#requirements_met_for_guessing_phase?" do
    game = games(:beatle_seinfeld)
    game.collecting!

    assert_changes -> { game.reload.requirements_met_for_guessing_phase? }, to: false do
      players(
        :george_player_in_beatle_seinfeld,
        :kramer_player_in_beatle_seinfeld
      ).map(&:destroy!)
    end
  end

  test "#requirements_met_for_ended_phase?" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_george)
    playlist_guess.update!(guessed_player: nil)

    assert_changes -> { game.reload.requirements_met_for_ended_phase? }, from: false do
      playlist_guess.update!(guessed_player: playlist_guess.guessing_player)
    end
  end

  test "#transit_to_phase, from: :collecting, to: :guessing" do
    game = games(:beatle_seinfeld)
    game.collecting!

    kramers_playlist = games_beatle_playlists(:kramer_player_in_beatle_seinfeld_playlist)
    kramers_playlist.update!(
      song_1_url: "https://wrong",
      song_2_url: nil,
      song_3_url: nil
    )

    Games::Beatle::PlaylistGuess.of_game(game).delete_all

    assert_changes -> { game.reload.phase }, from: "collecting", to: "guessing" do
      assert_changes -> { Games::Beatle::PlaylistGuess.of_game(game).reload.count }, from: 0, to: 6 do
        game.transit_to_phase(:guessing)
      end
    end
  end

  test "#transit_to_phase, from: :guessing, to: :guessing" do
    game = games(:beatle_seinfeld)
    playlist_guess = games_beatle_playlist_guesses(:jerry_player_in_beatle_seinfeld_guessing_elaine)

    assert_predicate playlist_guess.guessed_player, :present?
    assert_no_changes -> { playlist_guess.reload.guessed_player } do
      game.transit_to_phase(:guessing)
    end
  end

  test "#transit_to_phase, from: :guessing, to: :ended" do
    game = games(:beatle_seinfeld)
    game.guessing!

    jerry, elaine, george, kramer = players(
      :jerry_player_in_beatle_seinfeld,
      :elaine_player_in_beatle_seinfeld,
      :george_player_in_beatle_seinfeld,
      :kramer_player_in_beatle_seinfeld
    ).each do |player|
      player.update!(final_points: 999, final_rank: 1)
    end

    game.transit_to_phase(:ended)

    assert_equal [1, 2], jerry.reload.values_at(:final_points, :final_rank)
    assert_equal [3, 1], elaine.reload.values_at(:final_points, :final_rank)
    assert_equal [0, 4], george.reload.values_at(:final_points, :final_rank)
    assert_equal [1, 2], kramer.reload.values_at(:final_points, :final_rank)
  end

  test "#transit_to_phase, from: :guessing, to: :collecting" do
    game = games(:beatle_seinfeld)
    game.guessing!

    assert_changes -> { game.reload.phase }, from: "guessing", to: "collecting" do
      game.transit_to_phase(:collecting)
    end
  end
end
