class Games::PhasesSectionComponent < Games::ProxyComponent
  def phases
    @game.class.phases.keys
  end
end
