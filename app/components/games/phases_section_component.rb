class Games::PhasesSectionComponent < Games::ProxyComponent
  def render?
    !game.ended?
  end

  def phases
    game.phases.keys
  end

  def to_dom_id
    dom_id(game, :phases_section)
  end
end
