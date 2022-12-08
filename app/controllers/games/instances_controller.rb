class Games::InstancesController < ApplicationController
  def new
    @game_instance = Game.find(params[:game_id]).new_game_instance
  end

  def create
    @game_instance = Game.find(params[:game_id]).new_game_instance(game_params)
    @game_instance.user = Current.user

    if @game_instance.save
      redirect_to my_game_path(@game_instance)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_params
    params.require(:game_instance).permit(:group_name)
  end
end
