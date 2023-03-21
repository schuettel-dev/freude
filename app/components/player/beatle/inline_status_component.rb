class Player::Beatle::InlineStatusComponent < ApplicationComponent
  attr_reader :player, :args

  DEFAULT_OPTIONS = {
    class: "h-6 w-6"
  }.freeze

  def initialize(player:, **args)
    @player = player
    @args = DEFAULT_OPTIONS.deep_dup.merge(args)
    super()
  end

  def phase
    player.game.phase
  end

  def to_dom_id
    dom_id(player, :inline_status)
  end
end
