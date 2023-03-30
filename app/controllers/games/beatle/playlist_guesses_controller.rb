class Games::Beatle::PlaylistGuessesController < ApplicationController
  before_action :set_and_authorize_game
  before_action :set_and_authorize_playlist_guess

  def update
    guessed_player = policy_scope(Games::Player).of_game(@game).find!(params[:playlist_guess][:guessed_player_id])
    @playlist_guess.update(guessed_player:)

    redirect_to game_path(@game)
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game, :guess?
  end

  def set_and_authorize_playlist_guess
    @playlist_guess = policy_scope(Games::Beatle::PlaylistGuess).of_game(@game).find!(params[:id])
    authorize @playlist_guess
  end
end
