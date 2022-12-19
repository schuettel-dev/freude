require "test_helper"

class Users::ColorBadgeComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(user: users(:mario))

    assert_selector "span", style: "background-color: #e60011;"
  end
end
