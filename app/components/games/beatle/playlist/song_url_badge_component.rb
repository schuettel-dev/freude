class Games::Beatle::Playlist::SongUrlBadgeComponent < ApplicationComponent
  attr_reader :song_url

  BADGE_COLORS = {
    valid: "text-green-600",
    invalid: "text-red-400",
    blank: "text-gray-500"
  }.freeze

  def initialize(song_url:)
    @song_url = song_url
    super()
  end

  def call
    tag.div(class: BADGE_COLORS[song_url.status]) do
      render HeroiconComponent.new(:"musical-note", class: "h-4 w-4")
    end
  end
end
