class Games::FinalRankingComponent < ApplicationComponent
  attr_reader :game, :highlight_player, :all

  def initialize(game:, highlight_player:, all: false)
    @game = game
    @highlight_player = highlight_player
    @all = all
    super()
  end

  def players
    game.players.top(all? ? nil : 3)
  end

  def fourth_exists?
    Player.where(final_rank: 4..).any?
  end

  def highlight_player?(player)
    highlight_player == player
  end

  def all?
    all
  end

  def to_dom_id
    dom_id(game, :final_rankings)
  end
end
