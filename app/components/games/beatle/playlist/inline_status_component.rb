class Games::Beatle::Playlist::InlineStatusComponent < ApplicationComponent
  attr_reader :playlist, :args

  DEFAULT_OPTIONS = {
    class: "h-6 w-6"
  }.freeze

  def initialize(playlist:, **args)
    @playlist = playlist
    @args = DEFAULT_OPTIONS.deep_dup.merge(args)
    super()
  end

  def phase
    playlist.player.game.phase
  end

  def to_dom_id
    dom_id(playlist, :inline_status)
  end
end
