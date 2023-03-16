class Player::Beatle::InlineStatusComponent < ApplicationComponent
  attr_reader :player

  def initialize(player:)
    @player = player
    super()
  end

  def phase
    player.game.phase
  end
end
