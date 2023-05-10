class Games::Beatle::CollectingPhaseComponent < ApplicationComponent
  attr_reader :player

  delegate :game, to: :player

  def initialize(player:)
    @player = player
    super()
  end
end
