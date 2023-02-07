class Games::ProxyComponent < ViewComponent::Base
  attr_reader :game, :user

  def initialize(game:, user:)
    @game = game
    @user = user
    super()
  end

  def call
    render target_component_klass.new(game:, user:)
  end

  def game_owner?
    game.user == user
  end

  def current_phase?(phase)
    game.phase == phase
  end

  private

  def target_component_klass
    self.class.to_s.split("::").insert(1, game.class.to_s.demodulize).join("::").constantize
  end
end
