require "test_helper"

class Users::NameWithColorBadgeComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(user: users(:mario))

    assert_selector "span", style: "background-color: #e60011;"
    assert_text "Mario"
  end
end
