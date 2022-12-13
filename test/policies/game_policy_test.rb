require "test_helper"

class GamePolicyTest < ActiveSupport::TestCase
  test "policy" do
    assert_permit users(:mario), Game, :index?
    assert_permit users(:mario), Game.new, :new?
    assert_permit users(:mario), Game.new, :create?

    assert_permit users(:mario), games(:beatle_mario_bros), :show?
    assert_permit users(:mario), games(:beatle_mario_bros), :edit?
    assert_permit users(:mario), games(:beatle_mario_bros), :update?
    assert_permit users(:mario), games(:beatle_mario_bros), :destroy?

    assert_not_permit users(:luigi), games(:beatle_mario_bros), :show?
    assert_not_permit users(:luigi), games(:beatle_mario_bros), :edit?
    assert_not_permit users(:luigi), games(:beatle_mario_bros), :update?
    assert_not_permit users(:luigi), games(:beatle_mario_bros), :destroy?
  end
end
