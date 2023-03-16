class Games::Beatle::Playlist::SongUrlBadgeComponent < ApplicationComponent
  attr_reader :song_url

  BADGE_COLORS = {
    valid: "text-green-600",
    invalid: "text-red-400",
    blank: "text-gray-500"
  }.freeze

  DEFAULT_OPTIONS = {
    class: "h-4 w-4"
  }.freeze

  def initialize(song_url:, **opts)
    @song_url = song_url
    @opts = DEFAULT_OPTIONS.deep_dup.merge(opts)
    super()
  end

  def call
    tag.div(class: BADGE_COLORS[song_url.status]) do
      render HeroiconComponent.new(:"musical-note", **@opts)
    end
  end
end
