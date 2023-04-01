class UserDecorator < SimpleDelegator
  def display_name
    name
  end
end
