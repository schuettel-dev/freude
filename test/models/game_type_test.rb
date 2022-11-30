require "test_helper"

class GameTypeTest < ActiveSupport::TestCase
  test "validations" do
    game_type = GameType.new
    assert_not game_type.valid?

    game_type.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "Description can't be blank"
      assert_includes errors, "Instance type can't be blank"
    end
  end

  # test "#new_game" do
  #   game_type = game_types(:beatle)
  #   game = game_type.new_game(user: users(:mario))
  #   assert_equal Game::Beatle, game.type.constantize
  # end
end
