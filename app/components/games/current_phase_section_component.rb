class Games::CurrentPhaseSectionComponent < Games::ProxyComponent
  def to_dom_id
    dom_id(game, :current_phase_section)
  end
end
