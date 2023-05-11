require "test_helper"

class ConicPieComponentTest < ViewComponent::TestCase
  test "render, completed" do
    render_inline new_component(100)

    assert_selector ".conic-pie", class: "conic-pie-complete" do |element|
      assert_match("--conic-pie-percent: 100%;", element["style"])
    end
  end

  test "render, completed, with options" do
    render_inline new_component(100, hole_scale: 0.3, hole_color: "#FAFAFA")

    assert_selector ".conic-pie", class: "conic-pie-complete" do |element|
      assert_match("--conic-pie-hole-scale: 0.3;", element["style"])
      assert_match("--conic-pie-hole-color: #FAFAFA;", element["style"])
    end
  end

  test "render, incomplete" do
    render_inline new_component(42)

    assert_selector ".conic-pie", class: "conic-pie-incomplete" do |element|
      assert_match("--conic-pie-percent: 42%;", element["style"])
    end
  end
end
