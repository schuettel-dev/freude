require "test_helper"

class BadgeComponentTest < ViewComponent::TestCase
  test "render, default theme" do
    render_inline(new_component) { "Look at me" }

    assert_selector "span", text: "Look at me", class: "bg-indigo-600 text-gray-100"
  end

  test "render, gray theme" do
    render_inline(new_component(theme: :gray)) { "Look at me" }

    assert_selector "span", text: "Look at me", class: "bg-gray-300 text-gray-700"
  end
end
