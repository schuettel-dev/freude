require "test_helper"

class Games::FinalRankingsControllerTest < ActionDispatch::IntegrationTest
  test "GET if game ended" do
    game = games(:beatle_seinfeld)
    sign_in :jerry
    get game_final_ranking_path(game)

    assert_response :success
  end

  test "not GET if game not ended" do
    game = games(:beatle_seinfeld)
    game.update_column(:phase, :guessing)
    sign_in :jerry

    assert_raises(Pundit::NotAuthorizedError) do
      get game_final_ranking_path(game)
    end
  end

  test "not GET if game ended, foreign user" do
    game = games(:beatle_seinfeld)
    sign_in :newman

    assert_raises(ActiveRecord::RecordNotFound) do
      get game_final_ranking_path(game)
    end
  end
end
