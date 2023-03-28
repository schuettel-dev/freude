class Game::RankPlayersWith
  def initialize(game)
    @game = game
  end

  def call(&)
    Game.transaction do
      reset_final_points_and_rank!
      yield
      rank_by_final_points!
    end
  end

  private

  attr_reader :game

  def reset_final_points_and_rank!
    game.players.update_all("final_points = NULL, final_rank = NULL") # rubocop:disable Rails/SkipsModelValidations
  end

  def rank_by_final_points!
    Game.connection.execute(rank_by_final_points_sql)
  end

  def rank_by_final_points_sql
    <<~SQL.squish
      WITH with_players_final_rank AS (
        SELECT p.id                                           AS player_id
             , RANK() OVER (PARTITION BY p.game_id
                                ORDER BY p.final_points DESC) AS final_rank
          FROM players p
         WHERE p.final_points IS NOT NULL
           AND p.game_id = #{game.id}
      )

      UPDATE players p
         SET final_rank = fr.final_rank
        FROM with_players_final_rank fr
       WHERE fr.player_id = p.id
    SQL
  end
end
