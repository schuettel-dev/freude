class Games::StateDescriptionComponent < ViewComponent::Base
  def initialize(game:)
    @game = game
    super()
  end

  def call
    render game_state_description_component.new(game: @game)
  end

  private

  def game_state_description_component
    "Games::#{@game.class.to_s.demodulize}::StateDescriptionComponent".constantize
  end
end
