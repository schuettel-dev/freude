class Games::Beatle::PlaylistsController < ApplicationController
  before_action :set_and_authorize_playlist

  def show
  end

  private

  def set_and_authorize_playlist
    game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    @playlist = policy_scope(Player::Beatle::Playlist).of_game(game).first
    authorize @playlist
  end
end
