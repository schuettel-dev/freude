class Games::Beatle::StateDescriptionComponent < ViewComponent::Base
  def initialize(game:)
    @game = game
    super()
  end

  def states
    @game.class.states.keys
  end

  def state_classes(state)
    class_names("text-gray-400": !game_state_further_than?(state))
  end

  private

  def game_state_further_than?(state)
    states.index(@game.state) >= states.index(state.to_s)
  end
end
