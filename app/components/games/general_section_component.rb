class Games::GeneralSectionComponent < Games::ProxyComponent
  def render?
    admin? || game_policy.leave?
  end

  def admin?
    game.user == user
  end

  def to_dom_id
    dom_id(game, :general_section)
  end

  def game_policy
    @game_policy ||= Pundit.policy!(user, game)
  end
end
