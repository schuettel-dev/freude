class EmbeddedPlayerComponent < ApplicationComponent
  attr_reader :song_url

  delegate :provider, to: :song_url

  def initialize(song_url:)
    @song_url = song_url
  end

  def spotify_src
    track_id = song_url.url.split("spotify.com/track/")&.dig(1)&.split("?")&.dig(0)

    return if track_id.nil?

    "https://open.spotify.com/embed/track/#{track_id}?utm_source=generator"
  end
end
