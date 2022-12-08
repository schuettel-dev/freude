require "test_helper"

class GameInstanceTest < ActiveSupport::TestCase
  test "validations" do
    game_instance = GameInstance.new(
      group_name: "Group game",
      user: users(:mario),
      game: games(:beatle),
      type: "GameInstance::Beatle"
    )

    assert_difference -> { GameInstance.count }, +1 do
      assert game_instance.save!
    end

    assert_predicate game_instance, :initialized?
    assert_match(/^[[:alnum:]]{5,}$/, game_instance.token)
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
