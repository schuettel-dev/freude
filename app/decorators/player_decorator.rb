class PlayerDecorator < SimpleDelegator
  def to_label
    [user.name, id]
  end
end
