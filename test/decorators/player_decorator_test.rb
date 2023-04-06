require "test_helper"

class PlayerDecoratorTest < ActiveSupport::TestCase
  test "#display_name" do
    assert_equal "Jerry", players(:jerry_player_in_beatle_seinfeld).decorate.display_name
  end

  test "#display_final_points" do
    assert_equal 1, players(:jerry_player_in_beatle_seinfeld).decorate.display_final_points
  end

  test "#display_final_rank" do
    assert_equal "2nd", players(:jerry_player_in_beatle_seinfeld).decorate.display_final_rank
  end
end
