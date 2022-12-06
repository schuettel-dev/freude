class SessionsController < ApplicationController
  skip_before_action :authenticate!
  before_action :redirect_if_signed_in, except: :destroy

  def new
    @form = SessionForm.new(params:)
  end

  def create
    @form = SessionForm.new(params:)

    if @form.valid?
      sign_in(@form.user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_sign_up_path
  end
end
