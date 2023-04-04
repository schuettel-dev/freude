class Games::Beatle::ResultsController < ApplicationController
  before_action :set_and_authorize_game

  def show
    @playlist = game.playlists.order(:id).limit(1).offset(params[:page] || 0).first
  end

  private

  def set_and_authorize_game
    authorize game, :results?
  end

  def game
    @game ||= policy_scope(Game).find_by!(url_identifier: params[:game_id])
  end
end
