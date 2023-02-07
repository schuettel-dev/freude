class Games::PhaseDescriptionComponent < Games::ProxyComponent
  def phases
    @game.class.phases.keys
  end
end
