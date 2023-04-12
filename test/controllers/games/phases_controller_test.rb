require "test_helper"

class Games::PhasesControllerTest < ActionDispatch::IntegrationTest
  test "non-admin" do
    game = games(:beatle_seinfeld)
    sign_in :elaine

    assert_raises(Pundit::NotAuthorizedError) do
      put game_phases_path(game), params: { phase: :irrelevant }
    end
  end

  test "admin, transition allowed" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)

    sign_in :jerry

    assert_changes -> { game.reload.phase }, from: "collecting", to: "guessing" do
      put game_phases_path(game), params: { phase: :guessing }
      follow_redirect!

      assert_response :success
    end
  end

  test "admin, transition not allowed" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :collecting)
    sign_in :jerry

    assert_no_changes -> { game.reload.phase } do
      put game_phases_path(game), params: { phase: :ended }
      follow_redirect!

      assert_response :success
    end
  end
end
