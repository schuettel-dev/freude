require "test_helper"

class FlashesComponentTest < ViewComponent::TestCase
  FakeFlash = Struct.new(:notice)

  test "render" do
    flash = FakeFlash.new("Something, something")
    render_inline new_component(flash:)

    assert_selector ".flashes", text: "Something, something"
  end
end
