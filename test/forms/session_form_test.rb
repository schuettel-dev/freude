require "test_helper"

class SessionFormTest < ActiveSupport::TestCase
  test "valid" do
    params = ActionController::Parameters.new(session: { token: "MARIOTOKEN" })
    form = SessionForm.new(params:)
    assert form.valid?
  end

  test "invalid, missing token" do
    params = ActionController::Parameters.new(session: { token: "" })
    form = SessionForm.new(params:)
    assert_not form.valid?
    assert_includes form.errors.to_a, "Token can't be blank"
  end

  test "invalid, invalid token" do
    params = ActionController::Parameters.new(session: { token: "INVALIDTOKEN" })
    form = SessionForm.new(params:)
    assert_not form.valid?
    assert_includes form.errors.to_a, "Token does not exist"
  end
end
