require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "#save!" do
    user = users(:mario)

    game = Game.new(
      group_name: "Group game",
      game_template: game_templates(:beatle),
      user:,
      type: "Game::Beatle"
    )

    assert_difference -> { Game.count }, +1 do
      assert game.save!
    end

    assert_predicate game, :collecting?
    assert_match(/^[[:alnum:]]{6,}$/, game.url_identifier)
    assert_match(/^[[:alnum:]]{5,}$/, game.join_token)
  end

  test "not #save!" do
    game = Game.new

    assert_no_difference -> { Game.count } do
      assert_not game.save
    end

    game.errors.to_a.tap do |errors|
      assert_includes errors, "Group name can't be blank"
      assert_includes errors, "User must exist"
      assert_includes errors, "Game template must exist"
      assert_includes errors, "Phase can't be blank"
    end
  end

  test "#next_phase" do
    game = Game::Beatle.new(phase: :collecting)

    assert_equal :guessing, game.next_phase

    game.phase = :guessing

    assert_equal :ended, game.next_phase

    game.phase = :ended

    assert_nil game.next_phase
  end

  test "#next_phase?" do
    game = Game::Beatle.new(phase: :collecting)

    assert_not game.next_phase?(:collecting)
    assert game.next_phase?(:guessing)
    assert_not game.next_phase?(:ended)
  end

  test "#initialize_player" do
    game = games(:beatle_mario_bros)
    user = users(:toad)

    assert_difference -> { user.players.count }, +1 do
      game.initialize_player(user:).save
    end

    player = game.players.find_by(user:)

    assert_predicate player.playlist, :present?
  end
end
