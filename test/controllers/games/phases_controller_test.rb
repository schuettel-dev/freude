require "test_helper"

class Games::PhasesControllerTest < ActionDispatch::IntegrationTest
  test "non-admin" do
    game = games(:beatle_mario_bros)
    sign_in :luigi

    assert_raises(Pundit::NotAuthorizedError) do
      put game_phase_path(game), params: { phase: :irrelevant }
    end
  end

  test "admin, transition forward, allowed" do
    game = games(:beatle_seinfeld)
    game.collecting!

    sign_in :jerry

    assert_changes -> { game.reload.phase }, from: "collecting", to: "guessing" do
      put game_phase_path(game), params: { phase: :guessing }
      follow_redirect!
      assert_response :success
    end
  end

  test "admin, transition forward, not allowed" do
    game = games(:beatle_mario_bros)
    sign_in :mario

    assert_no_changes -> { game.reload.phase } do
      put game_phase_path(game), params: { phase: :guessing }
      follow_redirect!
      assert_response :success
    end
  end

  test "admin, transition backward, allowed" do
    game = games(:beatle_seinfeld)

    sign_in :jerry

    assert_changes -> { game.reload.phase }, from: "guessing", to: "collecting" do
      put game_phase_path(game), params: { phase: :collecting }
      follow_redirect!
      assert_response :success
    end
  end

  test "admin, transition backward, not allowed" do
    game = games(:beatle_seinfeld)
    game.ended!

    sign_in :jerry

    assert_no_changes -> { game.reload.phase } do
      put game_phase_path(game), params: { phase: :guessing }
      follow_redirect!
      assert_response :success
    end
  end
end
