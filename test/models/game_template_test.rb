require "test_helper"

class GameTemplateTest < ActiveSupport::TestCase
  test "not #save!" do
    game_template = GameTemplate.new

    assert_not game_template.valid?

    game_template.errors.to_a.tap do |errors|
      assert_includes errors, "Name can't be blank"
      assert_includes errors, "Image can't be blank"
      assert_includes errors, "Description can't be blank"
      assert_includes errors, "URL identifier can't be blank"
      assert_includes errors, "Type can't be blank"
    end
  end
end
