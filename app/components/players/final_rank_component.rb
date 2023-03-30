class Players::FinalRankComponent < ApplicationComponent
  RANK_COLORS = {
    1 => "from-yellow-300 to-yellow-500",
    2 => "from-zinc-200 to-zinc-400",
    3 => "from-amber-600 to-amber-800 text-white"
  }.freeze

  DEFAULT_BG_COLOR = "from-white to-gray-200".freeze

  def initialize(player:)
    @player = player
    super()
  end

  def call
    tag.span(player.final_rank.ordinalize, class: css_classes)
  end

  private

  attr_reader :player

  def css_classes
    class_names(
      "inline-flex w-8 h-8 rounded-full text-xs items-center justify-center bg-gradient-to-br",
      bg_color_classes
    )
  end

  def bg_color_classes
    RANK_COLORS[player.final_rank] || DEFAULT_BG_COLOR
  end
end
