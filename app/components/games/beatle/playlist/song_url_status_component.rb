class Games::Beatle::Playlist::SongUrlStatusComponent < ApplicationComponent
  attr_reader :song_url

  def initialize(song_url:)
    @song_url = song_url
  end

  def text
    t("games.beatle.shared.song_url_statuses").fetch(song_url.status)
  end
end
