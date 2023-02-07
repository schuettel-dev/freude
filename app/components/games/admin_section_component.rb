class Games::AdminSectionComponent < Games::ProxyComponent
  def render?
    game_policy.admin?
  end
end
