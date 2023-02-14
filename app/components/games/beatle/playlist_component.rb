class Games::Beatle::PlaylistComponent < ApplicationComponent
  attr_reader :playlist

  def initialize(playlist:)
    @playlist = playlist
  end
end
