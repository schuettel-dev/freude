class SignUpsController < ApplicationController
  skip_before_action :authenticate!
  before_action :redirect_if_signed_in

  def new
    @user = User.new
    @rejoin_form = SessionForm.new(params: { session: { token: session_past_user_token }})
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end

  def session_past_user_token
    session.dig(:past_user, "token")
  end
end
