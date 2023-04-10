require "test_helper"

class Users::NameWithColorBadgeComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(user: users(:jerry))

    assert_selector "span", style: "background-color: #701e3e;"
    assert_text "Jerry"
  end
end
