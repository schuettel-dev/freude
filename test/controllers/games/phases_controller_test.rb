require "test_helper"

class Games::PhasesControllerTest < ActionDispatch::IntegrationTest
  test "non-admin"
  test "admin, transition forward, allowed"
  test "admin, transition forward, not allowed"
  test "admin, transition backward, allowed"
  test "admin, transition backward, not allowed"
end
