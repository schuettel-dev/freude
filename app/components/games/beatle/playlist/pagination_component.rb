class Games::Beatle::Playlist::PaginationComponent < ApplicationComponent
  attr_reader :ordered_playlists, :current_playlist

  delegate :game, to: :current_playlist

  def initialize(ordered_playlists:, current_playlist:)
    @ordered_playlists = ordered_playlists
    @current_playlist = current_playlist
  end

  def previous_playlist
    return if previous_playlist_index.negative?

    ordered_playlists[previous_playlist_index]
  end

  def next_playlist
    return if next_playlist_index >= ordered_playlists.size

    ordered_playlists[current_playlist_index.next]
  end

  private

  def previous_playlist_index
    @previous_playlist_index ||= current_playlist_index.pred
  end

  def current_playlist_index
    @current_playlist_index ||= ordered_playlists.index(current_playlist)
  end

  def next_playlist_index
    @current_playlist_index ||= current_playlist_index.next
  end

end
