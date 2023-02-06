class BadgeComponent < ViewComponent::Base
  THEMES = {
    indigo: "bg-indigo-600 text-gray-100",
    gray: "bg-gray-300 text-gray-700"
  }.freeze

  def initialize(theme: :indigo)
    @theme = theme
  end

  def call
    tag.span(content, class: css_classes)
  end

  private

  def css_classes
    class_names("px-3 rounded-full text-xs tracking-wide", theme)
  end

  def theme
    THEMES[@theme]
  end
end
