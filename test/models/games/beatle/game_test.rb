require "test_helper"

class Games::Beatle::GameTest < ActiveSupport::TestCase
  test "#save!" do
    user = users(:mario)

    game = Games::Beatle::Game.new(
      group_name: "Group game",
      game_template: game_templates(:beatle),
      user:,
    )

    assert_difference -> { Game.count }, +1 do
      assert game.save!
    end

    assert_predicate game, :collecting?
    assert_match(/^[[:alnum:]]{6,}$/, game.url_identifier)
    assert_match(/^[[:alnum:]]{5,}$/, game.join_token)
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
    game = games(:beatle_mario_bros)

    assert_changes -> { game.minimum_players_reached? }, to: false do
      game.players.excluding(
        players(:mario_player_in_beatle_mario_bros, :luigi_player_in_beatle_mario_bros)
      ).destroy_all
    end
  end

  test "#transition_allowed?, from: :collecting" do
    game = games(:beatle_mario_bros)
    game.phase = :collecting

    assert game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert_not game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :guessing" do
    game = games(:beatle_mario_bros)
    game.phase = :guessing

    assert game.transition_allowed?(to_phase: :collecting)
    assert game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#transition_allowed?, from: :ended" do
    game = games(:beatle_mario_bros)
    game.phase = :ended

    assert_not game.transition_allowed?(to_phase: :collecting)
    assert_not game.transition_allowed?(to_phase: :guessing)
    assert game.transition_allowed?(to_phase: :ended)
  end

  test "#minimal_requirements_met_for_phase?, :guessing" do
    skip "to be implemented"
  end

  test "#minimal_requirements_met_for_phase?, :ended" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :collecting, to: :guessing" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :guessing, to: :ended" do
    skip "to be implemented"
  end

  test "#transit_to!, from: :guessing, to: :collecting" do
    skip "to be implemented"
  end
end
