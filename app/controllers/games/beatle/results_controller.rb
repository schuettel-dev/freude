class Games::Beatle::ResultsController < ApplicationController
  before_action :set_and_authorize_game

  def show; end

  private

  def set_and_authorize_game
    @game = policy_scope(Game).find_by!(url_identifier: params[:game_id])
    authorize @game, :results?
  end
end
