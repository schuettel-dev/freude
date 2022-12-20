class GameDecorator < SimpleDelegator
  def display_state
    __getobj__.class.human_enum_name(:state, state)
  end

  def display_state_description
    __getobj__.class.human_enum_name(:state_description, state)
  end
end
