require "test_helper"

class HeroiconComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component("chevron-left", class: "w-13 h-13")

    assert_selector "div", class: "w-13 h-13"
    assert_selector "svg", count: 1
  end
end
