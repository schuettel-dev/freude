require "test_helper"

class GameTest < ActiveSupport::TestCase
  test "validations" do
    game_type = Game.new

    assert_not game_type.valid?

    game_type.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "Image can't be blank"
      assert_includes errors, "Description can't be blank"
      assert_includes errors, "URL identifier can't be blank"
      assert_includes errors, "Type can't be blank"
    end
  end

  test "#new_game_instance" do
    game = games(:beatle)

    game.new_game_instance.tap do |game_instance|
      assert_equal GameInstance::Beatle, game_instance.type.constantize
      assert_equal GameInstance::Beatle, game_instance.class
    end
  end
end
