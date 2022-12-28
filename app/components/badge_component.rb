class BadgeComponent < ViewComponent::Base
  def call
    tag.span(content, class: "px-3 rounded-full bg-indigo-600 text-gray-100 text-xs tracking-wide")
  end
end
