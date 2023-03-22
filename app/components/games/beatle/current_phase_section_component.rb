class Games::Beatle::CurrentPhaseSectionComponent < Games::CurrentPhaseSectionComponent
  delegate :playlist, to: :player
end
