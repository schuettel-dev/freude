class Games::Beatle::Player::PlaylistInlineStatusComponent < ApplicationComponent
  attr_reader :player, :args

  delegate :playlist, to: :player

  DEFAULT_OPTIONS = {
    class: "h-6 w-6"
  }.freeze

  def initialize(player:, **args)
    @player = player
    @args = DEFAULT_OPTIONS.deep_dup.merge(args)
    super()
  end

  def phase
    playlist.player.game.phase
  end

  def to_dom_id
    dom_id(player, :playlist_inline_status)
  end
end
