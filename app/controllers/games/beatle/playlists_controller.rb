class Games::Beatle::PlaylistsController < ApplicationController
  include Turbo::Broadcastable

  before_action :set_and_authorize_playlist

  def show; end

  def update
    @playlist.update(player_beatle_playlist_params)
    @playlist.broadcast_inline_statuses

    redirect_to game_beatle_playlist_path(@playlist.game)
  end

  private

  def set_and_authorize_playlist
    game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    @playlist = policy_scope(Player::Beatle::Playlist).of_game(game).first
    authorize @playlist
  end

  def player_beatle_playlist_params
    params.require(:player_beatle_playlist).permit(:song_1_url, :song_2_url, :song_3_url)
  end
end
