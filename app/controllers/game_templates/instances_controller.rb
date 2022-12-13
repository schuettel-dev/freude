class GameTemplates::InstancesController < ApplicationController
  def new
    game_template = GameTemplate.find(params[:game_template_id])
    @game = Game.new(game_template:)
  end

  def create
    game_template = GameTemplate.find(params[:game_template_id])

    @game = Game.new(game_template:)
    @game.assign_attributes(game_params.merge(user: Current.user))

    if @game.save
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:group_name)
  end
end
