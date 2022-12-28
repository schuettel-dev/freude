class Games::Beatle::PhaseChangesComponent < ViewComponent::Base
  attr_reader :game

  def initialize(game:)
    @game = game
    super()
  end
end
