require "test_helper"

class QrCodeComponentTest < ViewComponent::TestCase
  test "render" do
    render_inline new_component(url: "https://foo.bar")

    assert_selector "svg", count: 1
  end
end
