class ConicPieComponent < ApplicationComponent
  DEFAULTS = {
    class: "w-8 h-8",
    hole_scale: 0,
    hole_color: "#fff"
  }.freeze

  def initialize(percentage, **args)
    @percentage = percentage
    @args = DEFAULTS.dup.merge(args)
    super()
  end

  def call
    tag.div(class: css_classes, style:, **args.except(*DEFAULTS.keys))
  end

  private

  attr_reader :percentage, :args

  def css_classes
    class_names(
      "conic-pie opacity-90 hover:opacity-100",
      complete? ? "conic-pie-complete" : "conic-pie-incomplete",
      args[:class]
    )
  end

  def style
    [
      "--conic-pie-percent: #{percentage}%;",
      "--conic-pie-hole-scale: #{args[:hole_scale]};",
      "--conic-pie-hole-color: #{args[:hole_color]};"
    ].join
  end

  def complete?
    percentage == 100
  end
end
