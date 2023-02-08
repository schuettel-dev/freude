class Games::Beatle::PlaylistComponent < ApplicationComponent
  renders_many :players, "PlayerComponent"

  def initialize(playlist:)
    @playlist = playlist
  end
end
