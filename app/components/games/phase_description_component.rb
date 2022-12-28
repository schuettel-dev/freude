class Games::PhaseDescriptionComponent < Games::ProxyComponent
  def current_phase?(phase)
    game.phase == phase
  end

  def phases
    @game.class.phases.keys
  end
end
