class Games::PlayersSectionComponent < Games::ProxyComponent
  def to_dom_id
    dom_id(game, :players_section)
  end
end
