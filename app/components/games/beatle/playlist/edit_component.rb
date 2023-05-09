class Games::Beatle::Playlist::EditComponent < ApplicationComponent
  attr_reader :playlist

  def initialize(playlist:)
    @playlist = playlist
    super()
  end

  def to_dom_id
    dom_id(playlist, :edit)
  end
end
