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
end
