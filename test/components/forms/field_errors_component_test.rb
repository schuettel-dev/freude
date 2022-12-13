require "test_helper"

class Forms::FieldErrorsComponentTest < ViewComponent::TestCase
  test "render" do
    @game = Game.new
    @game.validate
    render_inline new_component(@game, :group_name)

    assert_selector "div", class: "text-red-400", text: "can't be blank"
  end
end
