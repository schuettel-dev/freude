class Games::ProxyComponent < ViewComponent::Base
  attr_reader :game

  def initialize(game:)
    @game = game
    super()
  end

  def call
    render target_component_klass.new(game: @game)
  end

  private

  def target_component_klass
    self.class.to_s.split("::").insert(1, @game.class.to_s.demodulize).join("::").constantize
  end
end
