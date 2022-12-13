require "test_helper"

class Links::BackToComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component("/target_path", "Go to target")

    assert_link "Go to target", href: "/target_path"
  end
end
