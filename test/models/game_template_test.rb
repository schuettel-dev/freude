require "test_helper"

class GameTemplateTest < ActiveSupport::TestCase
  test "not #save!" do
    game_template = GameTemplate.new

    assert_not game_template.valid?

    game_template.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "Image can't be blank"
      assert_includes errors, "Description can't be blank"
      assert_includes errors, "Minimum players can't be blank"
      assert_includes errors, "URL identifier can't be blank"
      assert_includes errors, "Namespace can't be blank"
    end
  end

  test "#new_game" do
    game_template = game_templates(:beatle)

    game_template.new_game.tap do |instance|
      assert_equal Games::Beatle::Game, instance.class
      assert_equal game_template, instance.game_template
    end
  end
end
