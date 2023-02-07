class Games::PhaseChangesComponent < Games::ProxyComponent
  def render?
    game.user == user
  end
end
