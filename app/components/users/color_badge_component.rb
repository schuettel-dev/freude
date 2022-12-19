class Users::ColorBadgeComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
    super()
  end

  def call
    tag.span(nil, class: "block w-6 h-6 rounded-lg border-4 border-white/60", style:)
  end

  private

  def style
    "background-color: #{@user.color};"
  end
end
