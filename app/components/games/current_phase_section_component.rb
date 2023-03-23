class Games::CurrentPhaseSectionComponent < Games::ProxyComponent
  def player
    @player ||= Player.find_by!(game:, user:)
  end

  def to_dom_id
    dom_id(game, :current_phase_section)
  end
end
