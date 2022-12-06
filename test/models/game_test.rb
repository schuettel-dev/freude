require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "validations" do
    game = Game.new(
      name: "New game",
      user: users(:mario),
      game_type: game_types(:beatle),
      state: :new,
      type: "Game::Beatle"
    )

    assert_difference -> { Game.count }, +1 do
      assert game.save!
    end
  end

  test "invalid" do
    game = Game.new

    assert_no_difference -> { Game.count } do
      assert_not game.save
    end

    game.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "User must exist"
      assert_includes errors, "Game type must exist"
      assert_includes errors, "State can't be blank"
      assert_includes errors, "Type can't be blank"
      assert_includes errors, "Type is not included in the list"
    end
  end
end
