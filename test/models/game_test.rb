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

    assert_predicate game, :initialized?
    assert_match(/^[[:alnum:]]{6,}$/, game.url_identifier)
    assert_match(/^[[:alnum:]]{5,}$/, game.token)
    assert_equal 1, game.players.count
    assert_equal user, game.players.first.user
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
      assert_includes errors, "State can't be blank"
    end
  end
end
