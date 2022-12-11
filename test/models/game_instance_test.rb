require "test_helper"

class GameInstanceTest < ActiveSupport::TestCase
  test "validations" do
    user = users(:mario)

    game_instance = games(:beatle).new_game_instance(
      group_name: "Group game",
      user:
    )

    assert_difference -> { GameInstance.count }, +1 do
      assert game_instance.save!
    end

    assert_predicate game_instance, :initialized?
    assert_match(/^[[:alnum:]]{6,}$/, game_instance.url_identifier)
    assert_match(/^[[:alnum:]]{5,}$/, game_instance.token)
    assert_equal 1, game_instance.players.count
    assert_equal user, game_instance.players.first.user
  end

  test "invalid" do
    game_instance = GameInstance.new

    assert_no_difference -> { GameInstance.count } do
      assert_not game_instance.save
    end

    game_instance.errors.to_a.tap do |errors|
      assert_includes errors, "Group name can't be blank"
      assert_includes errors, "User must exist"
      assert_includes errors, "Game must exist"
      assert_includes errors, "State can't be blank"
      assert_includes errors, "Type can't be blank"
    end
  end
end
