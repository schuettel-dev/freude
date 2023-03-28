require "test_helper"

class Game::RankPlayersWithTest < ActiveSupport::TestCase
  test "ranking not influenced by other games players" do
    game = games(:beatle_seinfeld)

    mario, jerry, elaine = players(
      :mario_player_in_beatle_mario_bros,
      :jerry_player_in_beatle_seinfeld,
      :elaine_player_in_beatle_seinfeld
    )

    mario.update!(final_points: 5, final_rank: 99)
    jerry.update!(final_rank: 72)
    elaine.update!(final_rank: 71)

    Game::RankPlayersWith.new(game).call do
      jerry.reload.update!(final_points: 4)
      elaine.reload.update!(final_points: 3)
    end

    [mario, jerry, elaine].each(&:reload)

    assert_equal 5, mario.final_points
    assert_equal 99, mario.final_rank

    assert_equal 4, jerry.final_points
    assert_equal 1, jerry.final_rank

    assert_equal 3, elaine.final_points
    assert_equal 2, elaine.final_rank
  end

  test "ranking with equal final_points" do
    game = games(:beatle_seinfeld)

    jerry, elaine, george = players(
      :jerry_player_in_beatle_seinfeld,
      :elaine_player_in_beatle_seinfeld,
      :george_player_in_beatle_seinfeld
    )

    Game::RankPlayersWith.new(game).call do
      jerry.reload.update!(final_points: 4)
      elaine.reload.update!(final_points: 4)
      george.reload.update!(final_points: 3)
    end

    [jerry, elaine, george].each(&:reload)

    assert_equal 4, jerry.final_points
    assert_equal 1, jerry.final_rank

    assert_equal 4, elaine.final_points
    assert_equal 1, elaine.final_rank

    assert_equal 3, george.final_points
    assert_equal 3, george.final_rank
  end

  test "ranking with final_points having NULL" do
    game = games(:beatle_seinfeld)

    jerry, elaine, george = players(
      :jerry_player_in_beatle_seinfeld,
      :elaine_player_in_beatle_seinfeld,
      :george_player_in_beatle_seinfeld
    )

    Game::RankPlayersWith.new(game).call do
      jerry.reload.update!(final_points: 4)
      elaine.reload.update!(final_points: 3)
      george.reload.update!(final_points: nil)
    end

    [jerry, elaine, george].each(&:reload)

    assert_equal 4, jerry.final_points
    assert_equal 1, jerry.final_rank

    assert_equal 3, elaine.final_points
    assert_equal 2, elaine.final_rank

    assert_nil george.final_points
    assert_nil george.final_rank
  end
end
