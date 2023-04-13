class Games::FinalRankingsController < ApplicationController
  before_action :set_and_authorize_game

  def show
    raise Pundit::NotAuthorizedError unless @game.ended?

    @player = @game.players.find_by!(user: Current.user)
  end

  private

  def set_and_authorize_game
    @game ||= policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game
  end
end
