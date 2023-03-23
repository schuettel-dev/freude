class Games::PhasesSectionComponent < Games::ProxyComponent
  def phases
    @game.class.phases.keys
  end

  def to_dom_id
    dom_id(game, :phases_section)
  end
end
