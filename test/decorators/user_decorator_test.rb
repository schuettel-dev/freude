require "test_helper"

class UserDecoratorTest < ActiveSupport::TestCase
  test "#display_name" do
    assert_equal "Peanuts", User.new(name: "Peanuts").decorate.display_name
  end
end
