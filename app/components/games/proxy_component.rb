class Games::ProxyComponent < ApplicationComponent
  attr_reader :player

  delegate :game, :user, to: :player

  def initialize(player:)
    @player = player
    super()
  end

  def call
    render target_component_klass.new(player:)
  end

  def game_owner?
    game.user == user
  end

  private

  def game_policy
    @game_policy ||= Pundit.policy!(user, game)
  end

  def target_component_klass
    self.class.to_s.split("::").insert(1, game.class.to_s.split("::").second).join("::").safe_constantize
  end
end
