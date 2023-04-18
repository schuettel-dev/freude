class Games::PhasesSectionComponent < Games::ProxyComponent
  def render?
    !game.ended?
  end

  def phases
    game.phases.keys
  end
end
