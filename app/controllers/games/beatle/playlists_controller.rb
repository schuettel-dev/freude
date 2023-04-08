class Games::Beatle::PlaylistsController < ApplicationController
  before_action :set_and_authorize_game
  before_action :set_and_authorize_playlist

  def show
    @player = @game.players.find_by!(user: Current.user)
  end

  def edit; end

  def update
    @playlist.update(player_beatle_playlist_params)
    @playlist.broadcast_inline_statuses

    redirect_to edit_game_beatle_playlist_path(@playlist.game, @playlist)
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game, :show?
  end

  def set_and_authorize_playlist
    @playlist = @game.playlists.find(params[:id])
    authorize @playlist
  end

  def player_beatle_playlist_params
    params.require(:games_beatle_playlist).permit(:song_1_url, :song_2_url, :song_3_url)
  end
end
