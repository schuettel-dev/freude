require "test_helper"

class Games::Beatle::PaginationComponentTest < ViewComponent::TestCase
  test "not render, no items" do
    component = new_component([], :a)
    assert_not component.render?
  end

  test "not render, one item" do
    component = new_component([:a], :a)
    assert_not component.render?
  end
end
