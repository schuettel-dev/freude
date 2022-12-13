require "test_helper"

class GamePolicyTest < ActiveSupport::TestCase
  test "policy" do
    assert_permit users(:mario), Game, :index?
    assert_permit users(:mario), Game.new, :new?
    assert_permit users(:mario), Game.new, :create?

    assert_permit users(:mario), games(:beatle_mario), :show?
    assert_permit users(:mario), games(:beatle_mario), :edit?
    assert_permit users(:mario), games(:beatle_mario), :update?
    assert_permit users(:mario), games(:beatle_mario), :destroy?

    assert_not_permit users(:luigi), games(:beatle_mario), :show?
    assert_not_permit users(:luigi), games(:beatle_mario), :edit?
    assert_not_permit users(:luigi), games(:beatle_mario), :update?
    assert_not_permit users(:luigi), games(:beatle_mario), :destroy?
  end
end
