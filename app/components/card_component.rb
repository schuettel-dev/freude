class CardComponent < ApplicationComponent
  def initialize(padding: true)
    @padding = padding
    super
  end

  def call
    tag.div(content, class: css_classes)
  end

  private

  def padding?
    @padding
  end

  def css_classes
    class_names(
      to_css_class,
      "border-8 bg-white border-indigo-600 rounded-lg border-t-2 border-l-2": true,
      "p-4": padding?
    )
  end
end
