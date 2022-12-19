class Users::NameWithColorBadgeComponent < ViewComponent::Base
  attr_reader :user

  def initialize(user:)
    @user = user
    super()
  end
end
