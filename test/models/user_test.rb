require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "initializes token" do
    koopa = User.new(name: "Koopa")

    assert koopa.save!
    assert_match(/^[[:alnum:]]{16}$/, koopa.token)
  end

  test "token is readonly" do
    user = users(:mario)
    user.update!(token: "ANOTHERTOKEN")
    user.reload

    assert_equal "MARIOTOKEN", user.token
  end
end
