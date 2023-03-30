class Games::Beatle::PlaylistGuessesController < ApplicationController
  before_action :set_and_authorize_game
  before_action :set_and_authorize_playlist_guess

  def edit; end

  def update
    guessed_player = @game.players.where.not(user: Current.user).find_by(id: games_beatle_playlist_guess_params[:guessed_player_id])
    @playlist_guess.update(guessed_player:)

    redirect_to edit_game_beatle_playlist_guess_path(@game, @playlist_guess)
  end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game, :guess?
  end

  def set_and_authorize_playlist_guess
    @playlist_guess = policy_scope(Games::Beatle::PlaylistGuess).of_game(@game).find(params[:id])
    authorize @playlist_guess
  end

  def games_beatle_playlist_guess_params
    params.require(:games_beatle_playlist_guess).permit(:guessed_player_id)
  end
end
