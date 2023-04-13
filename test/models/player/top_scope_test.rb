require "test_helper"

class Player::TopScopeTest < ActiveSupport::TestCase
  setup do
    @game = games(:beatle_seinfeld)
  end

  test ".top, -1" do
    assert_equal 0, @game.players.top(-1).count
  end

  test ".top, 0" do
    assert_equal 0, @game.players.top(0).count
  end

  test ".top, 1" do
    @game.players.top(1).tap do |players|
      assert_equal 1, players.count
      assert_includes players, players(:elaine_player_in_beatle_seinfeld)
    end
  end

  test ".top, 2" do
    @game.players.top(2).tap do |players|
      assert_equal 3, players.count
      assert_includes players, players(:elaine_player_in_beatle_seinfeld)
      assert_includes players, players(:jerry_player_in_beatle_seinfeld)
      assert_includes players, players(:kramer_player_in_beatle_seinfeld)
    end
  end

  test ".top, 999" do
    @game.players.top(999).tap do |players|
      assert_equal @game.players.count, players.count
    end
  end

  test ".top, nil" do
    @game.players.top(nil).tap do |players|
      assert_equal @game.players.count, players.count
    end
  end
end
