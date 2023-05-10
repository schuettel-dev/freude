class Games::Beatle::Playlist::ShowComponent < ApplicationComponent
  attr_reader :playlist

  def initialize(playlist:)
    @playlist = playlist
    super()
  end
end
