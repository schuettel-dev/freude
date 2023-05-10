class Games::Beatle::EndedPhaseComponent < ApplicationComponent
  attr_reader :player

  delegate :game, to: :player

  def initialize(player:)
    @player = player
    super()
  end

  def initial_playlist
    game.playlists.order_by_user_name.first
  end
end
