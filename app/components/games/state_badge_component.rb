class Games::StateBadgeComponent < ViewComponent::Base
  attr_reader :game

  def initialize(game:)
    @game = game
    super()
  end
end
