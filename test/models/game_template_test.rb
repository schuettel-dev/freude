require "test_helper"

class GameTemplateTest < ActiveSupport::TestCase
  test "not #save!" do
    game_template = GameTemplate.new

    assert_not game_template.valid?

    game_template.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "Description can't be blank"
      assert_includes errors, "Minimum players can't be blank"
      assert_includes errors, "Free players can't be blank"
      assert_includes errors, "Maximum players can't be blank"
      assert_includes errors, "URL identifier can't be blank"
      assert_includes errors, "Namespace can't be blank"
    end
  end

  test "#new_game" do
    game_template = game_templates(:beatle)

    game_template.new_game.tap do |instance|
      assert_equal Games::Beatle::Game, instance.class
      assert_equal game_template, instance.game_template
      assert_equal "Beatle", instance.name
      assert_equal "Guess who's behind a playlist of 3 songs", instance.description
      assert_equal 3, instance.minimum_players
      assert_equal 10, instance.activated_players
      assert_equal 30, instance.maximum_players
    end
  end
end
