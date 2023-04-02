class Games::Beatle::PhasesSectionComponent < Games::PhasesSectionComponent
  def render?
    !game.ended?
  end
end
