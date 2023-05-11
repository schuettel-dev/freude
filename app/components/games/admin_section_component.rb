class Games::AdminSectionComponent < Games::ProxyComponent
  def render?
    game_policy.admin?
  end

  def to_dom_id
    dom_id(game, :admin_section)
  end
end
