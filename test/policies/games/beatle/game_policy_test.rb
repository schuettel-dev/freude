require "test_helper"

class Games::Beatle::GamePolicyTest < ActiveSupport::TestCase
  test "policy" do
    assert_permit users(:jerry), Game, :index?
    assert_permit users(:jerry), Game.new, :new?
    assert_permit users(:jerry), Game.new, :create?

    assert_permit users(:jerry), games(:beatle_seinfeld), :show?
    assert_permit users(:jerry), games(:beatle_seinfeld), :edit?
    assert_permit users(:jerry), games(:beatle_seinfeld), :update?
    assert_permit users(:jerry), games(:beatle_seinfeld), :destroy?
    assert_permit users(:jerry), games(:beatle_seinfeld), :admin?
    assert_not_permit users(:jerry), games(:beatle_seinfeld), :leave?

    assert_permit users(:elaine), games(:beatle_seinfeld), :show?
    assert_not_permit users(:elaine), games(:beatle_seinfeld), :edit?
    assert_not_permit users(:elaine), games(:beatle_seinfeld), :update?
    assert_not_permit users(:elaine), games(:beatle_seinfeld), :destroy?
    assert_not_permit users(:elaine), games(:beatle_seinfeld), :admin?

    assert_not_permit users(:newman), games(:beatle_seinfeld), :show?
  end

  test "scope" do
    assert_includes Pundit.policy_scope(users(:jerry), Game), games(:beatle_seinfeld)
    assert_includes Pundit.policy_scope(users(:elaine), Game), games(:beatle_seinfeld)
    assert_not_includes Pundit.policy_scope(users(:newman), Game), games(:beatle_seinfeld)
  end
end
