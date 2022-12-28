class GameDecorator < SimpleDelegator
  def display_phase
    __getobj__.class.human_enum_name(:phase, phase)
  end

  def display_phase_description
    __getobj__.class.human_enum_name(:phase_description, phase)
  end
end
