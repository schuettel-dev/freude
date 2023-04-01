class PlayerDecorator < SimpleDelegator
  def display_name
    user.decorate.display_name
  end

  def display_final_points
    final_points
  end
end
