class Players::FinalRankComponent < ApplicationComponent
  RANK_COLORS = {
    1 => "bg-yellow-400",
    2 => "bg-zinc-300",
    3 => "bg-amber-700 text-white"
  }.freeze

  SIZES = {
    xs: "text-xs w-8 h-8",
    lg: "text-lg w-16 h-16"
  }.freeze

  DEFAULT_BG_COLOR = "bg-gray-200".freeze

  def initialize(player:, size: :xs)
    @player = player
    @size = size
    super()
  end

  def call
    tag.span(player.decorate.display_final_rank, class: css_classes)
  end

  private

  attr_reader :player, :size

  def css_classes
    class_names(
      "inline-flex rounded-full items-center justify-center",
      size_classes,
      bg_color_classes
    )
  end

  def bg_color_classes
    RANK_COLORS[player.final_rank] || DEFAULT_BG_COLOR
  end

  def size_classes
    SIZES.fetch(size)
  end
end
