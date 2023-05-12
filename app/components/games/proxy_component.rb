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

  private

  def target_component_klass
    self.class.to_s.split("::").insert(1, game.class.to_s.split("::").second).join("::").safe_constantize
  end
end
