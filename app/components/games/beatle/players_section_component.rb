class Games::Beatle::PlayersSectionComponent < Games::PlayersSectionComponent
  def render?
    !game.ended?
  end
end
