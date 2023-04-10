require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "initializes token" do
    user = User.new(name: "Babu")

    assert user.save!
    assert_match(/^[[:alnum:]]{16}$/, user.token)
    assert_equal 7, user.color.size
  end

  test "token is readonly" do
    user = users(:jerry)
    user.update!(token: "ANOTHERTOKEN")
    user.reload

    assert_equal "JERRYTOKEN", user.token
  end
end
