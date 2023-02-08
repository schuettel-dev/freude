class Games::CurrentPhaseSectionComponent < Games::ProxyComponent
  def player
    @player ||= Player.find_by!(game:, user:)
  end
end
